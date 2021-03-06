USE [GameClass]
GO
/****** Объект:  Trigger [dbo].[RegistryAutoUPDATE]    Дата сценария: 01/22/2013 18:59:49 ******/
SET ANSI_NULLS ON
GO
SET QUOTED_IDENTIFIER OFF
GO
CREATE TRIGGER [dbo].[RegistryAutoUPDATE] ON [dbo].[Registry] 
FOR INSERT, UPDATE, DELETE 
AS 
BEGIN 
DECLARE @idI INT 
DECLARE @idD INT 
DECLARE @idAction INT 
DECLARE @isdeleted INT 
DECLARE IDcursor CURSOR FOR SELECT I.id AS [idI], D.id AS [idD] 
FROM INSERTED AS I 
FULL OUTER JOIN DELETED AS D ON I.id = D.id 
OPEN IDcursor 
FETCH NEXT FROM IDcursor INTO @idI, @idD 
WHILE @@FETCH_STATUS = 0 
BEGIN 
IF NOT(@idI IS NULL) AND (@idD IS NULL) 
SET @idAction = 1 --Insert 
IF (@idI IS NULL) AND NOT(@idD IS NULL) 
SET @idAction = 2 --Delete 
IF NOT(@idI IS NULL) AND NOT(@idD IS NULL) 
SET @idAction = 3 --Update 
INSERT AutoUpdate(idTable, idAction, idRecord) VALUES(3/*Registry*/, @idAction, ISNULL(@idI,@idD)) 
FETCH NEXT FROM IDcursor INTO @idI, @idD 
END 
CLOSE IDcursor 
DEALLOCATE IDcursor 
END 
