USE [master]
-- create a login for jobe that's a sysadmin
CREATE LOGIN [jobe_runner] WITH PASSWORD=N'jobe_runner', DEFAULT_DATABASE=[master], CHECK_EXPIRATION=OFF, CHECK_POLICY=OFF;
GO
EXEC master..sp_addsrvrolemember @loginame = N'jobe_runner', @rolename = N'sysadmin'
GO
CHECKPOINT
GO
SHUTDOWN
GO
