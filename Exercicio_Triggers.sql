/*
- Uma empresa vende produtos alimentícios
- A empresa dá pontos, para seus clientes, que podem ser revertidos em prêmios
- Para não prejudicar a tabela venda, nenhum produto pode ser deletado, mesmo que não venha mais a ser vendido
- Para não prejudicar os relatórios e a contabilidade, a tabela venda não pode ser alterada. 
- Ao invés de alterar a tabela venda deve-se exibir uma tabela com o nome do último cliente que comprou e o valor da 
última compra
- Após a inserção de cada linha na tabela venda, 10% do total deverá ser transformado em pontos.
- Se o cliente ainda não estiver na tabela de pontos, deve ser inserido automaticamente após sua primeira compra
- Se o cliente atingir 1 ponto, deve receber uma mensagem dizendo que ganhou
Tabela Cliente (Codigo | Nome)

Tabela Venda (Codigo_Venda | Codigo_Cliente | Valor_Total)

Tabela Pontos (Codigo_Cliente | Total_Pontos)

*/

USE master
GO
DROP DATABASE Exercicio_Triggers
GO
CREATE DATABASE Exercicio_Triggers
GO
USE Exercicio_Triggers
GO

CREATE TABLE Tabela_Cliente (
Codigo				INT,
Nome				VARCHAR(100) NOT NULL
PRIMARY KEY(Codigo)
)

GO

CREATE TABLE Tabela_Venda (
Codigo_Venda		INT,
Codigo_Cliente		INT,
Valor_Total			DECIMAL(7,2) NOT NULL
PRIMARY KEY(Codigo_Venda, Codigo_Cliente)
FOREIGN KEY (Codigo_Cliente) REFERENCES Tabela_Cliente(Codigo)
)

GO

CREATE TABLE Tabela_Pontos (
Codigo_Cliente		INT,
Total_Pontos		DECIMAL(7,2) DEFAULT(0)
PRIMARY KEY(Codigo_Cliente)
FOREIGN KEY (Codigo_Cliente) REFERENCES Tabela_Cliente(Codigo)
)

GO

-- Após a inserção de cada linha na tabela venda, 10% do total deverá ser transformado em pontos.
-- Se o cliente ainda não estiver na tabela de pontos, deve ser inserido automaticamente após sua primeira compra
-- Se o cliente atingir 1 ponto, deve receber uma mensagem dizendo que ganhou
CREATE TRIGGER t_addVenda ON Tabela_Venda
FOR INSERT
AS
BEGIN
	DECLARE @pontos			DECIMAL(7,2),
			@codigo_cliente INT,
			@erro			VARCHAR(MAX)

	SET @codigo_cliente = (SELECT Codigo_Cliente FROM INSERTED)
	SET @pontos= (SELECT Valor_Total FROM INSERTED)*0.1

	IF((SELECT COUNT(Codigo_Cliente) FROM Tabela_Pontos WHERE Codigo_Cliente = @codigo_cliente)=0)
	BEGIN
		INSERT INTO Tabela_Pontos VALUES
			(@codigo_cliente, @pontos)
	END
	ELSE
	BEGIN
		UPDATE dbo.Tabela_Pontos
		SET Total_Pontos = @pontos+Total_Pontos
		WHERE Codigo_Cliente = @codigo_cliente
	END

	IF(FLOOR(@pontos)>1)
	BEGIN
		PRINT 'PARABENS VOCÊ GANHOU '+CAST(FLOOR(@pontos) AS VARCHAR(MAX))+' PONTOS!'
	END
END

GO
-- Para não prejudicar os relatórios e a contabilidade, a tabela venda não pode ser alterada. 
-- Ao invés de alterar a tabela venda deve-se exibir uma tabela com o nome do último cliente que comprou e o valor da última compra

CREATE TRIGGER t_blockAlterVenda ON Tabela_Venda
FOR UPDATE
AS
BEGIN
	ROLLBACK TRANSACTION
	SELECT TOP 1 c.Nome, v.Valor_Total FROM Tabela_Venda v INNER JOIN Tabela_Cliente c
	ON v.Codigo_Cliente = c.Codigo 
	ORDER BY v.Codigo_Venda DESC;
END

GO
------------------------------------------------------------------------------------------

INSERT INTO Tabela_Cliente VALUES
(1,'Fulano'),
(2,'Ciclano')

INSERT INTO Tabela_Venda VALUES
(1, 1, 25.99)
INSERT INTO Tabela_Venda VALUES
(2, 1, 55.99)
INSERT INTO Tabela_Venda VALUES
(3, 1, 30.00)
INSERT INTO Tabela_Venda VALUES
(4, 2, 5.00)

SELECT * FROM Tabela_Pontos

SELECT * FROM Tabela_Venda

DELETE Tabela_Pontos
DELETE Tabela_Venda

UPDATE Tabela_Venda
SET Valor_Total = 50
WHERE Codigo_Cliente=1