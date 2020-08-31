--power(x,x)

--1) Criar um database, fazer uma tabela cadastro (cpf, nome, rua, numero e cep)com uma procedure que só permitirá a 
--inserção dos dados se o CPF for válido, caso contrário retornar uma mensagem de erro

CREATE DATABASE EX31082020
GO
USE EX31082020
GO
CREATE TABLE cadastro(
	cpf		CHAR(11)		NOT NULL,
	nome	VARCHAR(100)	NOT NULL,
	rua		VARCHAR(100)	NOT NULL,
	numero	INT				NOT NULL,
	cep		CHAR(8)			NOT NULL
	PRIMARY KEY (cpf)
)
GO
CREATE PROCEDURE sp_validacpf (	@cpf CHAR(11), 
								@valido CHAR(1) OUTPUT)
	AS
	DECLARE	@cont INT,
		@prime INT,
		@res INT,
		@aux INT

	SET @valido = 'V'
	SET @aux = 1

	WHILE(@valido = 'V' AND @aux <= 2)
	BEGIN

		SET @cont = 1
		SET @res = 0

		WHILE (@cont <= 8+@aux)
		BEGIN
		SET	@res = @res + (CAST(SUBSTRING(@cpf, @cont, 1) AS INT) * ((10+@aux)-@cont))
		SET @cont = @cont + 1
		END

		IF(@res%11 < 0)
		BEGIN
			SET @res = 0
		END
		ELSE
		BEGIN
			SET @res = 11-(@res%11)
		END

		IF(SUBSTRING(@cpf, (9+@aux), 1) != @res)
		BEGIN
			SET @valido = 'F'
		END

		SET @aux = @aux + 1	
	END

GO
 
CREATE PROCEDURE sp_inserecadastro (@cpf CHAR(11), 
									@nome VARCHAR(100),		
									@rua VARCHAR(100), 
									@numero INT, 
									@cep CHAR(8), 
									@texto VARCHAR(MAX) OUTPUT)
AS
DECLARE @valido CHAR(1) 
EXEC sp_validacpf @cpf, @valido OUTPUT

IF(UPPER(@valido)='V')
BEGIN
	INSERT INTO cadastro VALUES
	(@cpf, @nome, @rua, @numero, @cep)
	SET @texto = 'Inserido com sucesso'
END
ELSE
BEGIN
	RAISERROR('CPF invalido', 16, 1)
END

DECLARE @out VARCHAR(MAX)
EXEC sp_inserecadastro '22233366639', 'kesia', 'nomerua', 11, '08380444', @out OUTPUT
PRINT @out

