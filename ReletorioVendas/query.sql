CREATE DATABASE Vendas
GO
USE Vendas
GO

CREATE TABLE cliente(
cpf				CHAR(11)		PRIMARY KEY NOT NULL,
nome			VARCHAR(100)	NOT NULL,
ddd				CHAR(2)			NOT NULL,
telefone		CHAR(9)			NOT NULL,
email			VARCHAR(50)		NOT NULL,
senha			CHAR(8)			NOT NULL
)

GO

INSERT INTO cliente VALUES
('11111111111','Elvis','11','111111111','elvis@.com','123'),
('11111111112','Sandro','11','111111112','Sandro@.com','123'),
('11111111113','Oswaldo','11','111111113','Oswaldo@.com','123'),
('11111111114','Claudio','11','111111114','Claudio@.com','123')

GO

CREATE TABLE produto(
id				INT	PRIMARY KEY NOT NULL,
nome			VARCHAR(40)		NOT NULL,
descricao		VARCHAR(200)	NOT NULL,
valor_un		DECIMAL(7,2)	NOT NULL
)

GO

INSERT INTO produto VALUES
(1, 'Rodo', 'Rodo Noviça', 20.00),
(2, 'Vassoura', 'Vassoura Noviça', 15.00),
(3, 'Flanela', 'Flanela Noviça', 5.00),
(4, 'Pano', 'Pano Noviça', 7.00)

GO

CREATE TABLE compra(
cpf_cliente		CHAR(11)		FOREIGN KEY REFERENCES cliente(cpf) NOT NULL,
id_produto		INT				FOREIGN KEY REFERENCES produto(id) NOT NULL,
dt_compra		DATETIME		NOT NULL,
qtd				INT				NOT NULL,
valor_total		DECIMAL(7,2)	NOT NULL
PRIMARY KEY (cpf_cliente, id_produto, dt_compra)
)

GO

CREATE PROCEDURE insereCompra(@cpf_cliente CHAR(11), @id_produto INT, @dt_compra DATETIME, @qtd INT)
AS
	INSERT INTO compra VALUES
		(@cpf_cliente,@id_produto, @dt_compra,@qtd,(SELECT valor_un FROM produto WHERE id = @id_produto)*@qtd)

GO

EXEC insereCompra '11111111111',1,'17/05/2021',1
EXEC insereCompra '11111111111',2,'17/05/2021',1
EXEC insereCompra '11111111111',3,'17/05/2021',4
EXEC insereCompra '11111111112',3,'17/05/2021',4

GO

CREATE alter FUNCTION fn_Compras(@cpf_cliente CHAR(11), @dt_compra DATETIME)
RETURNS @table TABLE(
cpf_cliente				CHAR(11)		,
nome_cliente			VARCHAR(100)	,
telefone_cliente		CHAR(13)			,
email_cliente			VARCHAR(50)		,
id_produto				INT				,
nome_produto			VARCHAR(40)		,
qtd_venda				INT	,
valor_total_venda		DECIMAL(7,2)	,
dt_venda				DATETIME
)
AS
BEGIN
	INSERT INTO @table (cpf_cliente,nome_cliente,telefone_cliente,email_cliente,id_produto,nome_produto
																	,qtd_venda,valor_total_venda,dt_venda)
		(SELECT c.cpf, c.nome, '('+c.ddd+')'+c.telefone AS telefone_cliente, c.email,
				p.id, p.nome, v.qtd, 
				v.valor_total, v.dt_compra
			FROM cliente c INNER JOIN compra v
			ON c.cpf = v.cpf_cliente 
			INNER JOIN produto p 
			ON v.id_produto = p.id
			WHERE c.cpf = @cpf_cliente AND v.dt_compra = @dt_compra)
	RETURN
END

GO

SELECT cpf_cliente,nome_cliente,telefone_cliente,
			email_cliente,id_produto,nome_produto,qtd_venda,valor_total_venda,dt_venda  
FROM fn_Compras('11111111111','17/05/2021')



