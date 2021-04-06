USE master
DROP DATABASE TriggerseUDF
GO
CREATE DATABASE TriggerseUDF
GO
USE TriggerseUDF

CREATE TABLE Produto (
Codigo			INT				IDENTITY,
Nome			VARCHAR(50)		NOT NULL,
Descricao		VARCHAR(100)	NOT NULL,
Valor_Unitario	DECIMAL(7,2)	NOT NULL
PRIMARY KEY (Codigo)
)
GO
INSERT INTO Produto VALUES
('panela','5L',24.99),
('lapis','2B',4.99)

CREATE TABLE Estoque(
Codigo_Produto		INT			,
Qtd_Estoque			INT			NOT NULL,
Estoque_Minimo		INT			NOT NULL
PRIMARY KEY (Codigo_Produto)
FOREIGN KEY (Codigo_Produto) REFERENCES Produto (Codigo)
)
GO
INSERT INTO Estoque VALUES
(1,5,3),
(2,8,3)

CREATE TABLE Venda(
Nota_Fiscal			BIGINT,
Codigo_Produto		INT			NOT NULL,
Quantidade			INT			NOT NULL
PRIMARY KEY (Nota_Fiscal, Codigo_Produto)
FOREIGN KEY (Codigo_Produto) REFERENCES Produto (Codigo)
)
GO
/*
Fazer uma TRIGGER AFTER na tabela Venda que, uma vez feito um INSERT, verifique se a
quantidade está disponível em estoque. Caso esteja, a venda se concretiza, caso contrário, a
venda deverá ser cancelada e uma mensagem de erro deverá ser enviada. A mesma TRIGGER
deverá validar, caso a venda se concretize, se o estoque está abaixo do estoque mínimo
determinado ou se após a venda, ficará abaixo do estoque considerado mínimo e deverá lançar
um print na tela avisando das duas situações.
*/

CREATE TRIGGER t_concretizaVenda ON Venda
FOR INSERT
AS
	DECLARE @qtd_venda			INT,
			@cod_produto		INT,
			@estoque_atual		INT,
			@estoque_min		INT

	SET @cod_produto = (SELECT Codigo_Produto FROM INSERTED)
	SET @qtd_venda = (SELECT Quantidade FROM INSERTED)
	SET @estoque_atual = (SELECT Qtd_Estoque FROM Estoque WHERE Codigo_Produto = @cod_produto)
	SET @estoque_min = (SELECT Estoque_Minimo FROM Estoque WHERE Codigo_Produto = @cod_produto)

	IF (@estoque_atual < @qtd_venda)
	BEGIN
		ROLLBACK TRANSACTION
		RAISERROR('Quantidade em estoque é inferior a quantidade de venda',16,1)
	END
	ELSE
	BEGIN
		SET @estoque_atual = @estoque_atual - @qtd_venda
		UPDATE Estoque 
		SET Qtd_Estoque = @estoque_atual
		WHERE Codigo_Produto = @cod_produto
	END

	IF (@estoque_atual < @estoque_min)
	BEGIN
		PRINT('Estoque está inferior a quantidade minina de estoque')
	END


GO

INSERT INTO Venda VALUES
(151515, 1, 3)

INSERT INTO Venda VALUES
(151515, 2, 7)

INSERT INTO Venda VALUES
(151517, 2, 3)

SELECT * FROM Venda
SELECT * FROM Estoque

GO
/*- Fazer uma UDF (User Defined Function) Multi Statement Table, que apresente, para uma dada
nota fiscal, a seguinte saída:
(Nota_Fiscal | Codigo_Produto | Nome_Produto | Descricao_Produto | Valor_Unitario |
Quantidade | Valor_Total*)
* Considere que Valor_Total = Valor_Unitário * Quantidade*/

CREATE FUNCTION fn_totalVenda(@notaFiscal BIGINT)
RETURNS @table TABLE (
Nota_Fiscal			BIGINT,
Codigo_Produto		INT,
Nome_Produto		VARCHAR(50),
Descricao_Produto	VARCHAR(100),
Valor_Unitario		DECIMAL(7,2),
Quantidade			INT,
Valor_Total			DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @table (Nota_Fiscal, Codigo_Produto, Nome_Produto, Descricao_Produto, Valor_Unitario, Quantidade, Valor_Total)
		SELECT v.Nota_Fiscal, p.Codigo, p.Nome, p.Descricao, p.Valor_Unitario, v.Quantidade, p.Valor_Unitario*v.Quantidade
		FROM Venda v INNER JOIN Produto p 
		ON v.Codigo_Produto = p.Codigo 
		WHERE v.Nota_Fiscal = @notaFiscal
	RETURN
END

SELECT * FROM fn_totalVenda(151515)