/*Exemplo Queries Dinâmicas:

https://pastebin.com/qkd9X5JF

Atividade:

Fazer no SQL Seever a solução do seguinte enunciado (Subir no GIT e enviar na tarefa):

Considere a tabela Produto com os seguintes atributos:
Produto (Codigo | Nome | Valor)
Considere a tabela ENTRADA e a tabela SAÍDA com os seguintes atributos:
(Codigo_Transacao | Codigo_Produto | Quantidade | Valor_Total)
Cada produto que a empresa compra, entra na tabela ENTRADA. Cada produto que 
a empresa vende, entra na tabela SAIDA.
Criar uma procedure que receba um código (‘e’ para ENTRADA e ‘s’ para SAIDA), 
criar uma exceção de erro para código inválido, receba o codigo_transacao, 
codigo_produto e a quantidade e preencha a tabela correta, com o valor_total de 
cada transação de cada produto.
*/

CREATE DATABASE ex0803
GO

USE ex0803
GO

CREATE TABLE produto(
	codigo	INT						,
	nome	VARCHAR(50)		NOT NULL,
	valor	DECIMAL(7,2)	NOT NULL
	PRIMARY KEY (codigo)
)
GO
CREATE TABLE entrada(
	codigo_transacao	INT						,
	codigo_produto		INT				NOT NULL,
	quantidade			INT				NOT NULL,
	valor_total			DECIMAL(7,2)	NOT NULL
	PRIMARY KEY (codigo_Transacao)
	FOREIGN KEY (codigo_produto) REFERENCES	produto(codigo)
)
GO

CREATE TABLE saida(
	codigo_transacao	INT						,
	codigo_produto		INT				NOT NULL,
	quantidade			INT				NOT NULL,
	valor_total			DECIMAL(7,2)	NOT NULL
	PRIMARY KEY (codigo_Transacao)
	FOREIGN KEY (codigo_produto) REFERENCES	produto(codigo)
)
GO

CREATE PROCEDURE sp_transacao (@cod CHAR, @codigo_transacao INT, @codigo_produto INT, @quantidade INT)
AS
	DECLARE @tabela	VARCHAR(10),
			@query	VARCHAR(MAX),
			@erro	VARCHAR(MAX),
			@valor	DECIMAL(7,2)

	IF (UPPER(@COD) = 'E')
		BEGIN
			SET @tabela = 'entrada'
		END
	ELSE IF (UPPER(@COD) = 'S')
		BEGIN
			SET @tabela = 'saida'
		END
	ELSE
		BEGIN
			RAISERROR('Operação invalida', 16, 1)
		END

	BEGIN TRY
		SET @valor = (SELECT valor FROM produto WHERE codigo = @codigo_produto) * @quantidade
		SET @query = 'INSERT INTO '+@tabela+' VALUES ('+CAST(@codigo_transacao AS VARCHAR(5))+', '+CAST(@codigo_produto AS VARCHAR(5))+', '+
					CAST(@quantidade AS VARCHAR(5))+', '+CAST(@valor AS VARCHAR(10))+')'
		EXEC (@query)
	END TRY
	BEGIN CATCH
		SET @erro = ERROR_MESSAGE()
		IF (@erro LIKE '%primary%')
		BEGIN
			RAISERROR('ID transacao duplicado', 16, 1)
		END
		ELSE	
		BEGIN
			RAISERROR('Erro de processamento', 16, 1)
		END
	END CATCH
	GO

	INSERT INTO produto VALUES
	(1, 'camisa', 25.90),
	(2, 'caneta', 1.90),
	(3, 'borracha', 5.90)
	GO

	--operacao invalida
	EXEC sp_transacao 1, 1, 1, 10
	EXEC sp_transacao 'c', 1, 1, 10

	EXEC sp_transacao 'e', 1, 1, 10
	EXEC sp_transacao 'e', 2, 1, 20

	select * from entrada
	select * from saida