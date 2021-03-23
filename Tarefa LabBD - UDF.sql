/*3) A partir das tabelas abaixo, faça:
Funcionário (Código, Nome, Salário)
Dependendente (Código_Funcionário, Nome_Dependente, Salário_Dependente)

a) Uma Function que Retorne uma tabela:
(Nome_Funcionário, Nome_Dependente, Salário_Funcionário, Salário_Dependente)

b) Uma Scalar Function que Retorne a soma dos Salários dos dependentes, mais a do funcionário.
*/

USE master
GO
DROP DATABASE ExFuncionarios
GO
CREATE DATABASE ExFuncionarios
GO
USE ExFuncionarios
GO

CREATE TABLE Funcionario (
Codigo		BIGINT		 IDENTITY,
Nome		VARCHAR(100) NOT NULL,
Salario		DECIMAL(7,2) NOT NULL
PRIMARY KEY (Codigo)
)

GO

INSERT INTO Funcionario VALUES
('Fulano', 1500),
('Ciclano', 3600),
('Beltrano', 6000)

GO

CREATE TABLE Dependente (
CodigoFuncionario	BIGINT,
NomeDependente		VARCHAR(100),
SalarioDependente	DECIMAL(7,2)
PRIMARY KEY (CodigoFuncionario,NomeDependente)
FOREIGN KEY (CodigoFuncionario) REFERENCES Funcionario (Codigo)
)

INSERT INTO Dependente VALUES
(1, 'Fulaninho1', 600),
(1, 'Fulaninho2', 600),
(1, 'Fulaninho3', 600),
(2, 'Ciclaninho1', 600),
(2, 'Ciclaninho2', 600),
(3, 'Beltraninho1', 600)

GO

CREATE FUNCTION fn_somaSalarioFuncDep(@cod INT)
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @somaSalarioDep  DECIMAL(7,2)

	SELECT @somaSalarioDep = SUM(D.SalarioDependente)+F.Salario
	FROM Funcionario f INNER JOIN Dependente d
	ON f.Codigo = d.CodigoFuncionario
	GROUP BY f.Salario, d.SalarioDependente, f.Codigo
	HAVING f.Codigo = @cod

	RETURN @somaSalarioDep
END

GO

SELECT dbo.fn_somaSalarioFuncDep(3) AS SOMA

GO

CREATE FUNCTION fn_tabSalarioFunDep()
RETURNS @table TABLE (
Codigo		BIGINT		 ,
Nome		VARCHAR(100) NOT NULL,
Salario		DECIMAL(7,2) NOT NULL,
SalarioDep	DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @table (Codigo, Nome, Salario)
		SELECT Codigo, Nome, Salario FROM Funcionario

	UPDATE @table
		SET SalarioDep = (SELECT dbo.fn_somaSalarioFuncDep(Codigo)-Salario)

	RETURN
END

GO

SELECT * FROM fn_tabSalarioFunDep()

/*4)A partir das tabelas abaixo, faça:
Cliente (CPF, nome, telefone, e-mail)
Produto (Código, nome, descrição, valor_unitário)
Venda (CPF_Cliente, Código_Produto, Quantidade, Data(Formato DATE))

a) Uma Function que Retorne uma tabela:
(Nome_Cliente, Nome_Produto, Quantidade, Valor_Total)

b) Uma Scalar Function que Retorne a soma dos produtos comprados na Última Compra

*/

USE master
GO
DROP DATABASE ExVenda
GO
CREATE DATABASE ExVenda
GO
USE ExVenda
GO

CREATE TABLE Cliente (
Cpf			CHAR(11)				,
Nome		VARCHAR(100)	NOT NULL,
Telefone	VARCHAR(11)				,
Email		VARCHAR(100)
PRIMARY KEY (Cpf)
)

GO

INSERT INTO Cliente VALUES
('111','Fulano','1199999999','Fulano@Fulano.com'),
('222','Beltrano','1199999999','Beltrano@Beltrano.com'),
('333','Ciclano','1199999999','Ciclano@Ciclano.com')

GO

CREATE TABLE Produto (
Codigo			INT				IDENTITY,
Nome			VARCHAR(100)	NOT NULL,
Descricao		VARCHAR(200)			,
ValorUnitario	DECIMAL(7,2)	NOT NULL
PRIMARY KEY (Codigo)
)

GO

INSERT INTO Produto (Nome, ValorUnitario) VALUES
('Borracha', 2.5),
('Caneta', 6.5),
('Caderno', 15)

GO

CREATE TABLE Venda (
CpfCliente		CHAR(11)		,
ProdutoCodigo	INT				,
Quantidade		INT		NOT NULL,
DataVenda		DATE	NOT NULL
PRIMARY KEY (CpfCliente, ProdutoCodigo, DataVenda)
FOREIGN KEY (CpfCliente) REFERENCES Cliente(Cpf),
FOREIGN KEY (ProdutoCodigo) REFERENCES Produto(Codigo)
)

GO

INSERT INTO Venda VALUES
('111',1,1, '30-03-2021'),
('222',1,2, '30-03-2021'),
('222',1,2, '15-03-2021'),
('111',2,3,'22-03-2021'),
('111',1,3,'22-03-2021'),
('111',2,2, '15-03-2021')

GO

CREATE FUNCTION fn_tabValorTotal()
RETURNS @table TABLE (
NomeCliente		VARCHAR(100),
NomeProduto		VARCHAR(100),
Quantidade		INT,
ValorTotal		DECIMAL(7,2)
)
AS
BEGIN
	INSERT INTO @table (NomeCliente, NomeProduto, Quantidade, ValorTotal)
		SELECT c.Nome, p.Nome, v.Quantidade, p.ValorUnitario*v.Quantidade FROM Cliente c, Produto p, Venda v
			WHERE v.CpfCliente = c.Cpf AND v.ProdutoCodigo = p.Codigo
	RETURN
END

GO

SELECT * FROM fn_tabValorTotal()

GO

CREATE FUNCTION fn_somaValorUltCompra()
RETURNS DECIMAL(7,2)
AS
BEGIN
	DECLARE @valorTotal		DECIMAL(7,2)
	
	SELECT @valorTotal = P.ValorUnitario * v.Quantidade
	FROM Venda v INNER JOIN Produto p
	ON v.ProdutoCodigo = p.Codigo
	WHERE v.DataVenda = (SELECT MAX(DataVenda) FROM Venda)

	RETURN @valorTotal
END

GO

SELECT dbo.fn_somaValorUltCompra()