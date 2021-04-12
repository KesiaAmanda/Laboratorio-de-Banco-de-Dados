-----------------------------------------------------------------------------------------
--     ###             ####              ###      ######   #####     #####     ###     --
--    #####   ### ###  ####      #####   ###      ### ###  ### ##   ##  ###   ####     --
--   ### ###  ### ###  ####         ###  ######   ######   ### ###  ## ####    ###     --
--   ### ###  ### ###  ####      ######  ### ###  ### ###  ### ###  #### ##    ###     --
--   #######   #####   ####     ### ###  ### ###  ### ###  ######   ###  ##    ###     --
--   ### ###    ###    # #####   ### ##  ## ###   ######   #####     #####   #######   --
-----------------------------------------------------------------------------------------

USE master
GO
DROP DATABASE Av1LabBD
GO
CREATE DATABASE Av1LabBD
GO
USE Av1LabBD
GO

-----------------------------------------------------------------------------------------
--TABELAS--------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

CREATE TABLE Times(
Codigo INT IDENTITY,
NomeTime VARCHAR(50) NOT NULL,
Cidade VARCHAR(50) NOT NULL,
Estadio VARCHAR(50) NOT NULL
PRIMARY KEY (Codigo)
)

GO

CREATE TABLE Grupos(
Grupo	CHAR(1),
CodigoTime INT
PRIMARY KEY (CodigoTime)
FOREIGN KEY (CodigoTime) REFERENCES Times (Codigo)
)

GO

CREATE TABLE Jogos(
CodigoTimeA	INT,
CodigoTimeB INT,
GolsTimeA	INT,
GolsTimeB	INT,
DataJogo	DATE
PRIMARY KEY (CodigoTimeA,CodigoTimeB)
FOREIGN KEY (CodigoTimeA) REFERENCES Times (Codigo),
FOREIGN KEY (CodigoTimeB) REFERENCES Times (Codigo)
)

GO

-----------------------------------------------------------------------------------------
--INSERT---------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

INSERT INTO Times VALUES
('Botafogo-SP', 'Ribeirão Preto', 'Santa Cruz'),
('Bragantino', 'Bragança Paulista',	'Nabi Abi Chedid'),
('Corinthians', 'São Paulo', 'Arena Corinthians'),
('Ferroviária', 'Araraquara', 'Fonte Luminosa'),
('Guarani', 'Campinas', 'Brinco de Ouro da Princesa'),
('Ituano', 'Itu', 'Novelli Júnior'),
('Mirassol', 'Mirassol', 'José Maria de Campos Maia'),
('Novorizontino', 'Novo Horizonte', 'Jorge Ismael de Biasi'),
('Oeste', 'Barueri', 'Arena Barueri'),
('Palmeiras', 'São Paulo', 'Allianz Parque'),
('Ponte Preta', 'Campinas', 'Moisés Lucarelli'),
('Red Bull Brasil', 'Campinas', 'Moisés Lucarelli'),
('Santos', 'Santos', 'Pacaembú'),
('São Bento', 'Sorocaba', 'Walter Ribeiro'),
('São Caetano', 'São Caetano do Sul', 'Anacletto Campanella'),
('São Paulo', 'São Paulo', 'Morumbi')

GO

-----------------------------------------------------------------------------------------
--TRIGGER--------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

CREATE TRIGGER t_validaJogo ON Jogos
FOR INSERT
AS
BEGIN
	DECLARE @timeA INT,
			@timeB INT

	SET @timeA = (SELECT CodigoTimeA FROM INSERTED)
	SET @timeB = (SELECT CodigoTimeB FROM INSERTED)

	IF((SELECT COUNT(DataJogo) FROM Jogos WHERE CodigoTimeA = @timeB AND CodigoTimeB = @timeA)>0
		OR (SELECT Grupo FROM Grupos WHERE CodigoTime = @timeA) = 
			(SELECT Grupo FROM Grupos WHERE CodigoTime = @timeB))
	BEGIN
		ROLLBACK TRANSACTION
	END
END

GO

CREATE TRIGGER t_validaGrupo ON Grupos
FOR UPDATE
AS
BEGIN
	DECLARE @grupo		CHAR(1),
			@codTime	INT,
			@especial	INT,
			@cond1		INT,
			@cond2		INT

	SET @grupo = (SELECT Grupo FROM INSERTED)
	SET @codTime = (SELECT CodigoTime FROM INSERTED)
	SET @especial = (SELECT COUNT(g.Grupo) FROM Times t INNER JOIN Grupos g 
					ON t.Codigo = g.CodigoTime
					WHERE (t.NomeTime = 'Corinthians' OR 
					t.NomeTime = 'Palmeiras' OR 
					t.NomeTime = 'Santos' OR 
					t.NomeTime = 'São Paulo') AND
					g.Grupo = @Grupo)

	IF((SELECT COUNT(Grupo) FROM Grupos WHERE CodigoTime=@codTime)>1 
		OR (SELECT COUNT(Grupo) FROM Grupos WHERE Grupo=@grupo)>4 
		OR @especial>1)
	BEGIN
		ROLLBACK TRANSACTION
	END
END

GO


-----------------------------------------------------------------------------------------
--DEFINIR OS GRUPOS----------------------------------------------------------------------
-----------------------------------------------------------------------------------------

--FUNÇÃO QUE RETORNA TODOS OS GRUPOS VALIDOS PARA DETERMINADO TIME 
CREATE FUNCTION fn_tabGrupos(@CodTime INT)
RETURNS @table TABLE (
Grupo			CHAR(1)
)
AS
BEGIN
	INSERT INTO @table (Grupo)
		SELECT dbo.fn_grupoValido('A',@CodTime)

	INSERT INTO @table (Grupo)
		SELECT dbo.fn_grupoValido('B',@CodTime)

	INSERT INTO @table (Grupo)
		SELECT dbo.fn_grupoValido('C',@CodTime)

	INSERT INTO @table (Grupo)
		SELECT dbo.fn_grupoValido('D',@CodTime)

	DELETE @table
	WHERE Grupo = 'F'

	RETURN
END

GO

--FUNÇÃO QUE VERIFICA E RETORNA SE DETERMINADO GRUPO É VALIDO PARA DETERMINADO TIME 
CREATE FUNCTION fn_grupoValido(@Grupo CHAR(1), @CodTime INT)
RETURNS CHAR(1) 
AS
BEGIN
	DECLARE @especial INT,
			@nomeTime VARCHAR(50)

	SET @especial = (SELECT COUNT(G.Grupo) FROM Times t INNER JOIN Grupos g 
					ON t.Codigo = g.CodigoTime
					WHERE (t.NomeTime = 'Corinthians' OR 
					t.NomeTime = 'Palmeiras' OR 
					t.NomeTime = 'Santos' OR 
					t.NomeTime = 'São Paulo') AND
					g.Grupo = @Grupo)

	SET @nomeTime = (SELECT NomeTime FROM Times WHERE Codigo=@CodTime)
	IF (@NomeTime LIKE 'Corinthians' OR @NomeTime LIKE 'Palmeiras' OR @NomeTime LIKE 'Santos' OR @NomeTime LIKE 'São Paulo')
	BEGIN
		IF (@especial=0)
		BEGIN
			RETURN @Grupo
		END
	END
	ELSE IF ((SELECT COUNT(Grupo) FROM Grupos WHERE Grupo=@Grupo)<3 
			AND @especial=0)
	BEGIN
		RETURN @Grupo
	END
	ELSE IF ((SELECT COUNT(Grupo) FROM Grupos WHERE Grupo=@Grupo)<4 
			AND @especial=1)
	BEGIN
		RETURN @Grupo
	END
	RETURN 'F'

END

GO

--PROC QUE DEFINE OS GRUPOS
CREATE PROCEDURE sp_difineGrupos
AS
	DELETE Grupos
	DELETE Jogos

	INSERT INTO Grupos(CodigoTime)
		SELECT Codigo FROM Times 

	--UPDATE Grupos 
	--SET Grupo = (SELECT TOP 1 Grupo FROM fn_tabGrupos(CodigoTime) ORDER BY NEWID());

	DECLARE @total	INT,
			@aux	INT

	SET @total = (SELECT COUNT(Codigo) FROM Times)
	SET @aux = 1

	WHILE (@aux <= @total)
	BEGIN
		UPDATE Grupos SET Grupo = (SELECT TOP 1 Grupo FROM fn_tabGrupos(@aux) ORDER BY NEWID()) 
		WHERE CodigoTime = @aux

		SET @aux = @aux+1
	END

GO

-----------------------------------------------------------------------------------------
--DEFINIR OS JOGOS-----------------------------------------------------------------------
-----------------------------------------------------------------------------------------

--RETORNA TIMES VALIDOS PARA O SORTEIO
CREATE FUNCTION fn_tabTimesValidos(@dataJogo DATE)
RETURNS @table TABLE (
CodigoTime		INT
)
AS
BEGIN
	INSERT INTO @table (CodigoTime)
			SELECT CodigoTime FROM Grupos

		DELETE @table
		WHERE	CodigoTime = (SELECT CodigoTimeB FROM Jogos WHERE CodigoTime = CodigoTimeB AND DataJogo = @dataJogo) OR 
				CodigoTime = (SELECT CodigoTimeA FROM Jogos WHERE CodigoTime = CodigoTimeA AND DataJogo = @dataJogo)
	RETURN
END

GO

--RETORNA TIMES ADVERSARIOS VALIDOS PARA O SORTEIO
CREATE FUNCTION fn_tabAdversariosValidos(@grupo CHAR(1), @codTime INT, @dataJogo DATE)
RETURNS @table TABLE (
CodigoTime		INT
)
AS
BEGIN
	INSERT INTO @table (CodigoTime)
			SELECT CodigoTime FROM Grupos WHERE Grupo != @grupo

		DELETE @table
		WHERE	CodigoTime = @codTime OR
				CodigoTime = (SELECT CodigoTimeB FROM Jogos WHERE CodigoTime = CodigoTimeB AND DataJogo = @dataJogo) OR 
				CodigoTime = (SELECT CodigoTimeA FROM Jogos WHERE CodigoTime = CodigoTimeA AND DataJogo = @dataJogo) OR 
				CodigoTime = (SELECT CodigoTimeB FROM Jogos WHERE @codTime = CodigoTimeA AND CodigoTime = CodigoTimeB) OR
				CodigoTime = (SELECT CodigoTimeA FROM Jogos WHERE CodigoTime = CodigoTimeA AND @codTime = CodigoTimeB)
			
	RETURN
END

GO

CREATE PROCEDURE sp_difinirRodadas
AS
	DECLARE @dataInicio			DATE,
			@dataJogo			DATE,
			@horaAtual			TIME,
			@horaLimite			TIME

	SET @horaLimite = DATEADD(SECOND,1,GETDATE())


	SET @dataInicio = '19-01-2019'
	SET @dataJogo = @dataInicio

	DELETE Jogos

	WHILE((SELECT COUNT(DataJogo) FROM Jogos)<96)
	BEGIN		  
		IF(DATEPART(WEEKDAY ,@dataJogo)=1 OR DATEPART(WEEKDAY ,@dataJogo)=4)
		BEGIN

			WHILE (SELECT COUNT(DataJogo) FROM Jogos WHERE DataJogo=@dataJogo)<8
			BEGIN
				EXEC sp_difineJogo @dataJogo

				SET @horaAtual = GETDATE()
				IF(@horaAtual>@horaLimite)
				BEGIN
					RETURN
				END
			END

			IF(DATEPART(WEEKDAY ,@dataJogo)=1)
			BEGIN
				SET @dataJogo = DATEADD(DAY, 3, @dataJogo)
			END
			ELSE 
			BEGIN
				SET @dataJogo = DATEADD(DAY, 4, @dataJogo)
			END
		END
		ELSE
		BEGIN
			SET @dataJogo = DATEADD(DAY, 1, @dataJogo)
		END
	END
	
GO

CREATE PROCEDURE sp_difineJogo(@dataJogo DATE)
AS
	DECLARE @grupo				CHAR(1),
			@codTimeA			INT,
			@codTimeB			INT
	
		SET @codTimeA = (SELECT TOP 1 CodigoTime FROM fn_tabTimesValidos(@dataJogo) ORDER BY NEWID())
		SET @grupo = (SELECT TOP 1 Grupo FROM Grupos WHERE CodigoTime = @codTimeA)
		
		SET @codTimeB = (SELECT TOP 1 CodigoTime FROM fn_tabAdversariosValidos(@grupo, @codTimeA, @dataJogo) ORDER BY NEWID())

		IF(@codTimeB>0)
		BEGIN
			INSERT INTO Jogos (CodigoTimeA,CodigoTimeB,DataJogo) VALUES
			(@codTimeA, @codTimeB, @dataJogo)
		END
		ELSE
		BEGIN
			DELETE Jogos
			WHERE DataJogo = @dataJogo
		END

GO

CREATE PROCEDURE sp_difinirJogos(@saida VARCHAR(MAX) OUTPUT)
AS
	DECLARE @aux	INT
	SET @aux = 0

	WHILE (@aux<96)
	BEGIN
		EXEC sp_difinirRodadas
		SET @aux = (SELECT COUNT(DataJogo) FROM Jogos)
	END

	SET @saida = 'Os jogos foram definidos com sucesso!'

-----------------------------------------------------------------------------------------
--FUNÇÕES QUE RETORNAM TABELAS DE SAIDA--------------------------------------------------
-----------------------------------------------------------------------------------------

CREATE FUNCTION fn_tabGruposFormados()
RETURNS @table TABLE (
Grupo			CHAR(1),
CodigoTime		INT,
NomeTime		VARCHAR(50)
)
AS
BEGIN
	INSERT INTO @table (Grupo, CodigoTime, NomeTime)
		SELECT g.Grupo, t.Codigo, t.NomeTime FROM Times t INNER JOIN Grupos g ON t.Codigo=g.CodigoTime 

	RETURN
END

GO

CREATE FUNCTION fn_tabJogos(@dataJogo DATE)
RETURNS @table TABLE (
NomeTimeA		VARCHAR(50),
NomeTimeB		VARCHAR(50)
)
AS
BEGIN
	INSERT INTO @table (NomeTimeA, NomeTimeB)
		SELECT NomeTimeA.NomeTime, NomeTimeB.NomeTime 
		FROM Times AS NomeTimeA 
		INNER JOIN Jogos
		ON NomeTimeA.Codigo = Jogos.CodigoTimeA
		INNER JOIN Times AS NomeTimeB 
		ON NomeTimeB.Codigo = Jogos.CodigoTimeB
		WHERE Jogos.DataJogo = @dataJogo
	RETURN
END

-----------------------------------------------------------------------------------------
--ETC------------------------------------------------------------------------------------
-----------------------------------------------------------------------------------------

GO

EXEC sp_difineGrupos

SELECT NomeTime FROM fn_tabGruposFormados() WHERE Grupo = ?

SELECT * FROM fn_tabGruposFormados() ORDER BY Grupo

DECLARE @out varchar(max)
EXEC sp_difinirJogos @out output
PRINT @out

SELECT NomeTimeA, NomeTimeB FROM fn_tabJogos('20-01-2019')

SELECT COUNT(DataJogo) FROM Jogos