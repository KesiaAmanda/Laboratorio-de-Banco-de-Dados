CREATE DATABASE campeonatobasquete
GO
USE campeonatobasquete

CREATE TABLE times(
id		INT			NOT NULL IDENTITY(4001,1) PRIMARY KEY,
nome	VARCHAR(50) NOT NULL UNIQUE,
cidade	VARCHAR(80) NOT NULL
)

GO

CREATE TABLE jogador(
codigo		INT				NOT NULL IDENTITY(900101,1) PRIMARY KEY,
nomeJogador VARCHAR(60)		NOT NULL UNIQUE,
sexo		CHAR(1)			NULL DEFAULT('M') CHECK(sexo = 'M' OR sexo = 'F'),
altura		DECIMAL(7,2)	NOT NULL,
dt_nasc		DATETIME		NOT NULL CHECK(dt_nasc < '01/01/2000'),
id_time		INT				NOT NULL FOREIGN KEY REFERENCES times(id),
CONSTRAINT chk_sx_alt
	CHECK ((sexo = 'M' AND altura >= 1.70) OR
			(sexo = 'F' AND altura >= 1.60))
)

GO

CREATE PROCEDURE sp_crudTimes(@cod CHAR(1), @id INT, @nome VARCHAR(50),
								@cidade VARCHAR(80), @saida VARCHAR(MAX) OUTPUT)
AS
	IF (UPPER(@cod) = 'I' OR UPPER(@cod) = 'D' OR UPPER(@cod) = 'U')
	BEGIN
		IF (UPPER(@cod) = 'I')
		BEGIN
			INSERT INTO times (nome, cidade)
			VALUES (@nome, @cidade)
			SET @saida = 'Inserido com Sucesso!'
		END
		IF(UPPER(@cod) = 'U')
		BEGIN
			UPDATE times
			SET nome = @nome, cidade = @cidade
			WHERE ID = @id
			SET @saida = 'Atualizado com Sucesso!'
		END
		IF(UPPER(@cod) = 'D')
		BEGIN
			DELETE times
			WHERE ID = @id
			SET @saida = 'Removido com Sucesso!'
		END
	END
	ELSE
	BEGIN
		RAISERROR('Operação inválida',16,1)
	END

GO

DECLARE @out VARCHAR(MAX)
EXEC sp_crudTimes 'i', null, 'Bulls', 'Anápolis', @out OUTPUT
PRINT @out

DECLARE @out VARCHAR(MAX)
EXEC sp_crudTimes 'i', null, 'Bills', 'Tatuí', @out OUTPUT
PRINT @out

DECLARE @out VARCHAR(MAX)
EXEC sp_crudTimes 'U', 4002, 'Bills', 'Boituva', @out OUTPUT
PRINT @out

DECLARE @out VARCHAR(MAX)
EXEC sp_crudTimes 'i', null, 'Thunders', 'Avaré', @out OUTPUT
PRINT @out

DECLARE @out VARCHAR(MAX)
EXEC sp_crudTimes 'd', 4003, null, null, @out OUTPUT
PRINT @out

SELECT * FROM times

GO

CREATE FUNCTION fn_jogadorIdade(@codigo INT)
RETURNS @table TABLE (
codigo			INT,
nomeJogador		VARCHAR(60),
sexo			CHAR(1),
altura			DECIMAL(7,2),
dt_nasc			CHAR(10),
idade			INT,
id				INT,
nome			VARCHAR(50),
cidade			VARCHAR(80)
)
AS
BEGIN
	DECLARE @dt_nasc	DATE,
			@idade		INT

	INSERT INTO @table (codigo, nomeJogador, sexo, altura, dt_nasc, id, nome, cidade) 
		SELECT j.codigo, j.nomeJogador, j.sexo, j.altura, 
				CONVERT(CHAR(10), j.dt_nasc, 103) AS dt_nasc, t.id, t.nome, t.cidade
				FROM jogador j INNER JOIN times t
				ON j.id_time = t.ID
				WHERE j.codigo = @codigo

	SET @dt_nasc = (SELECT dt_nasc FROM jogador WHERE codigo = @codigo)

	SET @idade = (SELECT DATEDIFF(DD, @dt_nasc, GETDATE()) / 365)

	UPDATE @table
	SET idade = @idade

	RETURN
END

GO 

INSERT INTO jogador (nomeJogador, sexo, altura, dt_nasc, id_time) VALUES
('Ciclano', 'M', 1.80, '01/01/1993', 4001),
('Beltrano', 'M', 1.80, '01/07/1993', 4001),
('Cido', 'M', 1.80, '01/12/1993', 4001),
('Amando', 'M', 1.80, '01/07/1990', 4002),
('Amado', 'M', 1.80, '01/01/1990', 4002),
('Rubens', 'M', 1.80, '01/12/1990', 4002)

SELECT * FROM fn_jogadorIdade(900102)