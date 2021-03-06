SELECT s.name,data_source,provider,
       is_remote_login_enabled,is_rpc_out_enabled,
       is_data_access_enabled,uses_self_credential,
       remote_name
  FROM sys.servers s INNER JOIN
       sys.linked_logins ll on s.server_id=ll.server_id
 WHERE s.server_id != 0
---------------------------------------------------------------------------
--(1) Use sp_addlinkedserver to create a linked server object and name it “LinkedServer” which points to the SQL instance on machine B, SQLB.
EXEC sp_addlinkedserver @server='DexmaSites',
		@srvproduct='DexmaSites',
		@provider='SQLNCLI',
		@datasrc='dexmasites.db.prod.dexma.com',--the data source
		@provstr="Integrated Security=SSPI;"

--(2) Use sp_addlinkedsrvlogin to configure login to use self-mapping as following
exec sp_addlinkedsrvlogin 'DexmaSites', 'true';

-- To verify if the command is executed correctly, run query
select * from sys.servers where name='DexmaSites';

--Step (2) makes middle server A try to use impersonated token of user to authenticate to server B. To verify that the linked server is setup for “self-mapping”, run query
select *, uses_self_credential as delegation
from sys.linked_logins as L, sys.servers as S
where S.server_id=L.server_id
and S.name=N'DexmaSites'


select * from dexmasites.dbamaint.dbo.dbusers

select * from dexmasites.master.dbo.sysdatabases
---------------------------------------------------------------------------
--To create a linked server to another instance of SQL Server using Transact-SQL

    --In Query Editor, enter the following Transact-SQL command to link to an instance of SQL Server named SRVR002\ACCTG:
    --Transact-SQL

    USE [master]
    GO
    --EXEC master.dbo.sp_addlinkedserver 
    --    @server = N'SRVR002\ACCTG', 
    --    @srvproduct=N'SQL Server' ;
    --GO
	EXEC sp_addlinkedserver 
		@server='DexmaSitesTest',
		@srvproduct='DexmaSites',
		@provider='SQLNCLI',
		@datasrc='dexmasites.db.prod.dexma.com'--,--the data source
		--@provstr="Integrated Security=SSPI;"

    --Execute the following code to configure the linked server to use the domain credentials of the login that is using the linked server.
    --Transact-SQL

    EXEC master.dbo.sp_addlinkedsrvlogin 
        @rmtsrvname = N'DexmaSites2', 
        @locallogin = NULL , 
        @useself = N'True' ;
    GO
---------------------------------------------------------------------------





select net_transport, auth_scheme from sys.dm_exec_connections where session_id=@@spid


SELECT
srv.srvname AS [Name],
CAST(srv.srvid AS int) AS [ID],
ISNULL(srv.catalog,N'') AS [Catalog],
ISNULL(srv.datasource,N'') AS [DataSource],
ISNULL(srv.location,N'') AS [Location],
srv.srvproduct AS [ProductName],
srv.providername AS [ProviderName],
null AS [ProviderString],
CAST(srv.collationcompatible AS bit) AS [CollationCompatible],
CAST(srv.dataaccess AS bit) AS [DataAccess],
CAST(srv.dist AS bit) AS [Distributor],
CAST(srv.dpub AS bit) AS [DistPublisher],
CAST(srv.pub AS bit) AS [Publisher],
CAST(srv.rpc AS bit) AS [Rpc],
CAST(srv.rpcout AS bit) AS [RpcOut],
CAST(srv.sub AS bit) AS [Subscriber],
CAST(ISNULL(COLLATIONPROPERTYFROMID(srv.srvcollation, 'name'),N'') AS sysname) AS [CollationName],
srv.connecttimeout AS [ConnectTimeout],
CAST(srv.lazyschemavalidation AS bit) AS [LazySchemaValidation],
srv.querytimeout AS [QueryTimeout],
CAST(srv.useremotecollation AS bit) AS [UseRemoteCollation],
srv.providerstring AS [ProviderStringIn]
FROM
master.dbo.sysservers AS srv
WHERE
(srv.srvid != 0)and(srv.srvname=N'BELLATRIX')

---------------------------------------------------------------------------
exec sp_enum_oledb_providers

EXECUTE master.dbo.xp_enum_oledb_providers

EXECUTE master.dbo.xp_prop_oledb_provider 'SQLOLEDB'

exec sp_linkedservers

exec sp_helplinkedsrvlogin

sp_enumoledbdatasources

----------------------------------------------------------------------------

select * from sqllinkedservers
where sourceserver != destinationserver
order by 1


-- Linked servers to decommissioned servers
SELECT SourceServer, DestinationServer, DataSource
FROM SQLLinkedServers
WHERE DestinationServer IN
(SELECT server_name from t_server where active = '0')


select SourceServer, DestinationServer, DestinationServerProduct, DataSource , DestinationServerCatalog, DestinationServerUser
from sqllinkedservers
where sourceserver != destinationserver
order by 1,2

select SourceServer, DestinationServer, DestinationServerProduct, DataSource , DestinationServerCatalog, DestinationServerUser
from sqllinkedservers
where sourceserver != destinationserver
order by 2,1


select SourceServer, DestinationServer, DestinationServerProduct, DataSource , DestinationServerCatalog, DestinationServerUser
from sqllinkedservers
where sourceserver != destinationserver
AND DestinationServerUser = ''
order by 2,1