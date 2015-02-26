# DatabaseErrorLog
儲存資料庫 (StoredProcedure) 執行錯誤的錯誤訊息，此項目為從 AdventureWorks 擷取出來的內容

<p>
此項目提供的資料庫指令碼擷取至微軟範例資料庫 AdventureWorks 2014
http://msftdbprodsamples.codeplex.com/releases/view/125550
<p>

<ul>
  <li>此資料庫指令碼為 SqlServer 使用</li>
  <li>可以下載微軟範例資料庫取得原始版本</li>
  <li>儲存目標依照執行預存程序的雙數與單數月份做區隔</li>
  <li>請依照實際執行情境進行必要的程式碼異動</li>
</ul>

<h4>使用方式</h4>
<p>
  執行資料庫指令碼<br/>
  若建立沒有問題的話於預存程序中 (StoredProcedure) 加入 TRY ... CATCH<br/>
  並在 CATCH 內容中呼叫預存程序 [dbo].[sp_AddDatabaseError]
</p>

<br/>

<h5>執行範例</h5>
<p>
  <pre>
  CREATE PRCEDURE xxxx
    ...
  AS
    BEGIN TRY
    
    END TRY
    
    BEGIN CATCH
      EXECUTE [dbo].[sp_AddDatabaseError]
    END CATCH
  GO
  </pre>
</p>
