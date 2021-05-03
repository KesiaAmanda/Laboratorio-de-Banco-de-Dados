--_____/\\\\\\\\\___________________/\\\_____________________________/\\\_________/\\\\\\\\\\\\\____/\\\\\\\\\\\\________/\\\\\\\_______/\\\\\\\\\_____        
-- ___/\\\\\\\\\\\\\________________\/\\\____________________________\/\\\________\/\\\/////////\\\_\/\\\////////\\\____/\\\/////\\\___/\\\///////\\\___       
--  __/\\\/////////\\\_______________\/\\\____________________________\/\\\________\/\\\_______\/\\\_\/\\\______\//\\\__/\\\____\//\\\_\///______\//\\\__      
--   _\/\\\_______\/\\\__/\\\____/\\\_\/\\\______________/\\\\\\\\\____\/\\\________\/\\\\\\\\\\\\\\__\/\\\_______\/\\\_\/\\\_____\/\\\___________/\\\/___     
--    _\/\\\\\\\\\\\\\\\_\//\\\__/\\\__\/\\\_____________\////////\\\___\/\\\\\\\\\__\/\\\/////////\\\_\/\\\_______\/\\\_\/\\\_____\/\\\________/\\\//_____    
--     _\/\\\/////////\\\__\//\\\/\\\___\/\\\_______________/\\\\\\\\\\__\/\\\////\\\_\/\\\_______\/\\\_\/\\\_______\/\\\_\/\\\_____\/\\\_____/\\\//________   
--      _\/\\\_______\/\\\___\//\\\\\____\/\\\______________/\\\/////\\\__\/\\\__\/\\\_\/\\\_______\/\\\_\/\\\_______/\\\__\//\\\____/\\\____/\\\/___________  
--      _\/\\\_______\/\\\____\//\\\_____\/\\\\\\\\\\\\\\\_\//\\\\\\\\/\\_\/\\\\\\\\\__\/\\\\\\\\\\\\\/__\/\\\\\\\\\\\\/____\///\\\\\\\/____/\\\\\\\\\\\\\\\_ 
--        _\///________\///______\///______\///////////////___\////////\//__\/////////___\/////////////____\////////////________\///////_____\///////////////__

/*criar uma Trigger que não permita INSERT, UPDATE ou
DELETE nas tabelas TIMES e GRUPOS e uma Trigger semelhante, mas apenas para INSERT e
DELETE na tabela jogos.*/

USE Av1LabBD
GO

CREATE TRIGGER t_blockTimes ON Times
FOR INSERT, UPDATE, DELETE
AS
BEGIN		
		ROLLBACK TRANSACTION
		RAISERROR('Os times já foram definidos!', 16, 1)
END 

GO

CREATE TRIGGER t_blockGrupos ON Grupos
FOR INSERT, UPDATE, DELETE
AS
BEGIN		
		ROLLBACK TRANSACTION
		RAISERROR('Os grupos já foram definidos!', 16, 1)
END
GO
DISABLE TRIGGER t_blockGrupos ON Grupos;  

GO

CREATE TRIGGER t_blockJogos ON Jogos
FOR INSERT, DELETE
AS
BEGIN		
		ROLLBACK TRANSACTION
		RAISERROR('Os jogos já foram definidos!', 16, 1)
END
GO
DISABLE TRIGGER t_blockJogos ON Jogos;  

GO

--------------------------------------
--Alterações
--------------------------------------

ALTER PROCEDURE sp_difineGrupos
AS
	DELETE Grupos
	DELETE Jogos

	INSERT INTO Grupos(CodigoTime)
		SELECT Codigo FROM Times 

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

	ALTER TABLE Grupos DISABLE TRIGGER t_validaGrupo
	ALTER TABLE Grupos ENABLE TRIGGER t_blockGrupos

GO

ALTER PROCEDURE sp_difinirJogos(@saida VARCHAR(MAX) OUTPUT)
AS
	DECLARE @aux	INT
	SET @aux = 0

	WHILE (@aux<96)
	BEGIN
		EXEC sp_difinirRodadas
		SET @aux = (SELECT COUNT(DataJogo) FROM Jogos)
	END

	SET @saida = 'Os jogos foram definidos com sucesso!'

	ALTER TABLE Jogos DISABLE TRIGGER t_validaJogo
	ALTER TABLE Jogos ENABLE TRIGGER t_blockJogos

GO

-----------------------------------------------------------------------------------------------
/*Fazer uma tela que, pelas datas dos jogos, seja possível inserir os resultados dos jogos, que
fará um UPDATE na tabela jogos, que já terá os times e data, com os gols marcados por cada
time.*/
-----------------------------------------------------------------------------------------------

CREATE PROCEDURE sp_difinePlacar(@codTimeA INT, @golsMandante INT, @codTimeB int, @golsVisitante INT, @saida VARCHAR(MAX) OUTPUT)
AS
	IF(@codTimeA>0 AND @codTimeB>0 AND @golsMandante>=0 AND @golsVisitante>=0)
	BEGIN
		UPDATE Jogos
		SET GolsTimeA = @golsMandante,
		GolsTimeB = @golsVisitante
		WHERE @codTimeA = CodigoTimeA AND @codTimeB = CodigoTimeB

		SET @saida = 'O placar foi definido com sucesso!'
	END
	ELSE
	BEGIN
		RAISERROR('Dados fornecidos são invalidos!', 16, 1)
	END

GO

-----------------------------------------------------------------------------------------------
/*Fazer uma tela de consulta com os 4 grupos e 4 Tabelas, que mostrem a saída (para cada
Tabela) de uma UDF (User Defined FUNCTION), que receba o nome do grupo, valide-o e dê a
seguinte saída:
GRUPO (nome_time, num_jogos_disputados*, vitorias, empates, derrotas, gols_marcados,
gols_sofridos, saldo_gols**,pontos***)
Deve-se fazer, para melhor visualização dos resultados, uma tela com a classificação geral,
numa UDF (User Defined FUNCTION), que receba o nome do grupo, valide-o e dê a seguinte
saída, para os 20 times do campeonato:
CAMPEONATO (nome_time, num_jogos_disputados*, vitorias, empates, derrotas,
gols_marcados, gols_sofridos, saldo_gols**,pontos***)*/
-----------------------------------------------------------------------------------------------
GO

CREATE FUNCTION fn_tabRebaixados()
RETURNS @table TABLE (
nome_time				VARCHAR(50))
AS
BEGIN
	INSERT INTO @table (nome_time)
			SELECT	TOP 4 nome_time 
					FROM fn_tabClassificacao('') 
					WHERE num_jogos_disputados > 0
					ORDER BY pontos, vitorias, gols_marcados, saldo_gols
	RETURN
END

GO

CREATE FUNCTION fn_tabClassificacao(@grupo VARCHAR(1))
RETURNS @table TABLE (
nome_time				VARCHAR(50),
num_jogos_disputados	INT,
vitorias				INT,
empates					INT,
derrotas				INT,
gols_marcados			INT,
gols_sofridos			INT,
saldo_gols				INT,
pontos					INT
)
AS
BEGIN
	IF ((SELECT COUNT(Grupo) FROM Grupos WHERE Grupo LIKE '%'+@grupo)>0)
	BEGIN
		INSERT INTO @table (nome_time, num_jogos_disputados, vitorias, empates, derrotas, gols_marcados, gols_sofridos)
			SELECT Times.NomeTime, (SELECT dbo.fn_infoJogos('J',Times.Codigo)), (SELECT dbo.fn_infoJogos('V',Times.Codigo)),
				(SELECT dbo.fn_infoJogos('E',Times.Codigo)), (SELECT dbo.fn_infoJogos('D',Times.Codigo)),
				(SELECT dbo.fn_infoJogos('M',Times.Codigo)), (SELECT dbo.fn_infoJogos('S',Times.Codigo))
			FROM Grupos INNER JOIN Times
			ON Grupos.CodigoTime = Times.Codigo
			WHERE Grupos.Grupo LIKE '%'+@grupo

		UPDATE @table
		SET saldo_gols = gols_marcados - gols_sofridos

		UPDATE @table
		SET pontos = (vitorias*3) + (empates*1)
	END
	RETURN
END

GO

CREATE FUNCTION fn_infoJogos(@op CHAR(2), @cod_Time INT)
RETURNS INT
AS
BEGIN
	DECLARE @valor	INT,
			@aux	INT

	SET @valor = 0

	IF(@op = 'J')
	BEGIN
		SET @valor = (SELECT COUNT(CodigoTimeA)FROM Jogos
		WHERE GolsTimeA>=0 AND GolsTimeB>=0 AND CodigoTimeA = @cod_Time)+
		(SELECT COUNT(CodigoTimeB) FROM Jogos
		WHERE GolsTimeA>=0 AND GolsTimeB>=0 AND CodigoTimeB = @cod_Time)
	END

	IF(@op = 'V')
	BEGIN
		SET @valor = (SELECT COUNT(GolsTimeA) FROM Jogos
		WHERE @cod_Time = CodigoTimeA AND GolsTimeA > GolsTimeB) +
		(SELECT COUNT(GolsTimeB) FROM Jogos
		WHERE @cod_Time = CodigoTimeB AND GolsTimeA < GolsTimeB) 
	END

	IF(@op = 'E')
	BEGIN
		SET @valor = (SELECT COUNT(GolsTimeA) FROM Jogos
		WHERE @cod_Time = CodigoTimeA AND GolsTimeA = GolsTimeB AND GolsTimeA > 0) +
		(SELECT COUNT(GolsTimeB) FROM Jogos
		WHERE @cod_Time = CodigoTimeB AND GolsTimeA = GolsTimeB AND GolsTimeB > 0)
	END

	IF(@op = 'D')
	BEGIN
		SET @valor = (SELECT COUNT(GolsTimeA) FROM Jogos
		WHERE @cod_Time = CodigoTimeA AND GolsTimeA < GolsTimeB) +
		(SELECT COUNT(GolsTimeB) FROM Jogos
		WHERE @cod_Time = CodigoTimeB AND GolsTimeA > GolsTimeB)
	END

	IF(@op = 'M')
	BEGIN
		SET @aux = (SELECT SUM(GolsTimeA) FROM Jogos
		WHERE @cod_Time = CodigoTimeA AND GolsTimeA > 0) 
		IF(@aux>0)
		BEGIN
			SET @valor = @aux
		END

		SET @aux = (SELECT SUM(GolsTimeB) FROM Jogos
		WHERE @cod_Time = CodigoTimeB AND GolsTimeB > 0)
		IF(@aux>0)
		BEGIN
			SET @valor = @valor+@aux
		END
	END

	IF(@op = 'S')
	BEGIN
	SET @aux = 0
		SET @aux = (SELECT SUM(GolsTimeB) FROM Jogos
		WHERE @cod_Time = CodigoTimeA AND GolsTimeB > 0)
		IF(@aux>0)
		BEGIN
			SET @valor = @aux
		END
		SET @aux = (SELECT SUM(GolsTimeA) FROM Jogos
		WHERE @cod_Time = CodigoTimeB AND GolsTimeA > 0)
		IF(@aux>0)
		BEGIN
			SET @valor = @valor+@aux
		END
	END

	RETURN @valor
END

GO

-----------------------------------------------------------------------------------------------
/*Por fim, uma tela deverá ser criada para ver a projeção das quartas de final. As quartas de final
serão disputadas entre o 1º e o 2º de cada grupo. Gerá-las a partir de UDF*/
-----------------------------------------------------------------------------------------------

CREATE FUNCTION fn_tabQuartasDeFinal(@grupo CHAR(1))
RETURNS @table TABLE (
nomeTimeA		VARCHAR(50),
nomeTimeB		VARCHAR(50))
AS
BEGIN
	DECLARE @nome_time VARCHAR(50)
	DECLARE c CURSOR FOR SELECT TOP 2 nome_time
							FROM fn_tabClassificacao(@grupo)
							WHERE num_jogos_disputados > 0
							ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_gols DESC

	OPEN c
	FETCH NEXT FROM c INTO @nome_time
	INSERT INTO @table (nomeTimeA) VALUES (@nome_time)
	FETCH NEXT FROM c INTO @nome_time
	UPDATE @table SET nomeTimeB = @nome_time

	CLOSE c
	DEALLOCATE c

	RETURN
END

SELECT nomeTimeA, nomeTimeB FROM fn_tabQuartasDeFinalAux('A')

GO

-----------------------------------------------------------------------------------------------

SELECT	nome_time, num_jogos_disputados, vitorias, empates, derrotas, 
		gols_marcados, gols_sofridos, saldo_gols, pontos 
		FROM fn_tabClassficacao('') 
		ORDER BY pontos DESC, vitorias DESC, gols_marcados DESC, saldo_gols DESC



SELECT	TOP 4 nome_time 
		FROM fn_tabClassficacao('') 
		ORDER BY pontos, vitorias, gols_marcados, saldo_gols

update jogos
set GolsTimeA = 1, GolsTimeB = 0

SELECT Grupo FROM fn_tabGruposFormados() GROUP BY Grupo

SELECT	TOP 4 nome_time, Grupo 
		FROM fn_tabClassficacao('') INNER JOIN Times
		ON Times.NomeTime = fn_tabClassficacao.nome_time
		INNER JOIN Grupos
		ON Times.Codigo = Grupos.CodigoTime
		ORDER BY pontos, vitorias, gols_marcados, saldo_gols


SELECT * FROM dbo.fn_tabQuartasDeFinal('A') 

UPDATE Jogos
SET GolsTimeA = CAST(RAND() * 5 AS INTEGER),
	GolsTimeB = CAST(RAND() * 5 AS INTEGER)

UPDATE Jogos
SET GolsTimeA = -1,
	GolsTimeB = -1