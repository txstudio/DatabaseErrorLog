--儲存雙數月份的 資料庫預存程序錯誤紀錄
CREATE TABLE [dbo].[DatabaseErrorLog-0] (
	[No] INT IDENTITY(1, 1) NOT NULL
	,[ErrorTime] DATETIME DEFAULT(GETDATE())
	,[ErrorDatabase] NVARCHAR(100)
	,[LoginName] NVARCHAR(100)
	,[UserName] NVARCHAR(128)
	,[ErrorNumber] INT
	,[ErrorSeverity] INT
	,[ErrorState] INT
	,[ErrorProcedure] NVARCHAR(130)
	,[ErrorLine] INT
	,[ErrorMessage] NVARCHAR(MAX)
	,CONSTRAINT [PK_dbo_DatabaseErrorLog-0_No] PRIMARY KEY CLUSTERED ([No] ASC) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

--儲存單數月份的 資料庫預存程序錯誤紀錄
CREATE TABLE [dbo].[DatabaseErrorLog-1] (
	[No] INT IDENTITY(1, 1) NOT NULL
	,[ErrorTime] DATETIME DEFAULT(GETDATE())
	,[ErrorDatabase] NVARCHAR(100)
	,[LoginName] NVARCHAR(100)
	,[UserName] NVARCHAR(128)
	,[ErrorNumber] INT
	,[ErrorSeverity] INT
	,[ErrorState] INT
	,[ErrorProcedure] NVARCHAR(130)
	,[ErrorLine] INT
	,[ErrorMessage] NVARCHAR(MAX)
	,CONSTRAINT [PK_dbo_DatabaseErrorLog-1_No] PRIMARY KEY CLUSTERED ([No] ASC) ON [PRIMARY]
	) ON [PRIMARY] TEXTIMAGE_ON [PRIMARY]
GO

--
--儲存資料庫執行錯誤的錯誤訊息
--
CREATE PROCEDURE [dbo].[sp_AddDatabaseError] @No INT = 0 OUTPUT
AS
DECLARE @seed INT

SET NOCOUNT ON
SET @No = 0

BEGIN TRY
	IF ERROR_NUMBER() IS NULL
	BEGIN
		RETURN
	END

	--
	--如果有進行中的交易正在使用時不進行記錄
	-- (尚未 rollback 或 commit)
	--
	IF XACT_STATE() = (- 1)
	BEGIN
		RETURN
	END

	SET @seed = (DATEPART(MONTH, GETDATE()) % 2)

	IF @seed = 0
	BEGIN
		--雙數月份時資料匯入至此
		INSERT INTO [dbo].[DatabaseErrorLog-0] (
			[ErrorDatabase]
			,[LoginName]
			,[UserName]
			,[ErrorNumber]
			,[ErrorSeverity]
			,[ErrorState]
			,[ErrorProcedure]
			,[ErrorLine]
			,[ErrorMessage]
			)
		VALUES (
			CONVERT(NVARCHAR(100), DB_NAME())
			,CONVERT(NVARCHAR(100), SYSTEM_USER)
			,CONVERT(NVARCHAR(128), CURRENT_USER)
			,ERROR_NUMBER()
			,ERROR_SEVERITY()
			,ERROR_STATE()
			,ERROR_PROCEDURE()
			,ERROR_LINE()
			,ERROR_MESSAGE()
			)
	END
	ELSE
	BEGIN
		--單數月份時資料匯入至此
		INSERT INTO [dbo].[DatabaseErrorLog-1] (
			[ErrorDatabase]
			,[LoginName]
			,[UserName]
			,[ErrorNumber]
			,[ErrorSeverity]
			,[ErrorState]
			,[ErrorProcedure]
			,[ErrorLine]
			,[ErrorMessage]
			)
		VALUES (
			CONVERT(NVARCHAR(100), DB_NAME())
			,CONVERT(NVARCHAR(100), SYSTEM_USER)
			,CONVERT(NVARCHAR(128), CURRENT_USER)
			,ERROR_NUMBER()
			,ERROR_SEVERITY()
			,ERROR_STATE()
			,ERROR_PROCEDURE()
			,ERROR_LINE()
			,ERROR_MESSAGE()
			)
	END

	SET @No = @@IDENTITY
END TRY

BEGIN CATCH
	RETURN (- 1)
END CATCH
GO
