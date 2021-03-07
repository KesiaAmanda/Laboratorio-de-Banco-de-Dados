--Tarefas Stored Procedure:

--Criar uma database chamada cadastro, criar uma tabela pessoa (CPF CHAR(11) PK, 
--nome VARCHAR(80)), pegar o algoritmo de validação de CPF, transformar em uma 
--Stored Procedure sp_inserepessoa, que receba como parâmetro @cpf e @nome e @saida 
--como parâmtero de saída. Valide o CPF e, só insira na tabela pessoa (cpf e nome) 
--com CPF válido e nome com LEN Maior que zero. @saida deve dizer que foi inserido 
--com sucesso. Raiserrors devem tratar violações.

CREATE DATABASE cadastro
GO
USE cadastro 
GO

CREATE TABLE pessoa (
cpf		CHAR(11)	NOT NULL,
nome	VARCHAR(80)	NOT NULL
PRIMARY KEY (cpf)
)

CREATE PROCEDURE sp_inserepessoa (@cpf CHAR(11), @nome VARCHAR(80), @saida VARCHAR(MAX) OUTPUT)
AS
	DECLARE	@valido BIT,
		@cont INT,
		@prime INT,
		@res INT,
		@aux INT

	SET @valido = 1
	SET @aux = 1

	WHILE(@valido = 1 AND @aux <= 2)
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
			SET @valido = 0
		END

		IF(@aux = 1)
		BEGIN
			SET @prime = @res
		END
		ELSE IF(@prime = @res)
		BEGIN
			SET @valido = 0
		END

		SET @aux = @aux + 1	
	END


	IF (@valido = 1 AND LEN(@nome)>0)
	BEGIN 
		INSERT INTO pessoa
		VALUES (@cpf, @nome)

		SET @saida = 'Pessoa inserida com sucesso'
	END
	ELSE
	BEGIN
		IF (LEN(@nome)=0)
		BEGIN
			RAISERROR('Nome de pessoa invalido', 16, 1)
		END
		IF (@valido = 0)
		BEGIN
			RAISERROR('CPF invalido', 16, 1)
		END
	END 


DECLARE @out VARCHAR(MAX)
EXEC sp_inserepessoa '94061617028', 'Fulano', @out OUTPUT
PRINT @out

DECLARE @out VARCHAR(MAX)
EXEC sp_inserepessoa '11111111111', 'Fulano', @out OUTPUT
PRINT @out

DECLARE @out VARCHAR(MAX)
EXEC sp_inserepessoa '94061617028', '', @out OUTPUT
PRINT @out


/*Exercício
Criar uma database chamada academia, com 3 tabelas como seguem:

Aluno
|Codigo_aluno|Nome|

Atividade
|Codigo|Descrição|IMC|

Atividade
codigo      descricao                           imc
----------- ----------------------------------- --------
1           Corrida + Step                       18.5
2           Biceps + Costas + Pernas             24.9
3           Esteira + Biceps + Costas + Pernas   29.9
4           Bicicleta + Biceps + Costas + Pernas 34.9
5           Esteira + Bicicleta                  39.9                                                                                                                                                                    

Atividadesaluno
|Codigo_aluno|Altura|Peso|IMC|Atividade|

IMC = Peso (Kg) / Altura² (M)

Atividade: Buscar a PRIMEIRA atividade referente ao IMC imediatamente acima do calculado.
* Caso o IMC seja maior que 40, utilizar o código 5.

Criar uma Stored Procedure (sp_alunoatividades), com as seguintes regras:
 - Se, dos dados inseridos, o código for nulo, mas, existirem nome, altura, peso, deve-se inserir um 
 novo registro nas tabelas aluno e aluno atividade com o imc calculado e as atividades pelas 
 regras estabelecidas acima.
 - Se, dos dados inseridos, o nome for (ou não nulo), mas, existirem código, altura, peso, deve-se 
 verificar se aquele código existe na base de dados e atualizar a altura, o peso, o imc calculado e 
 as atividades pelas regras estabelecidas acima.
*/

CREATE DATABASE academia
GO
USE academia
GO
CREATE TABLE aluno(
cod_aluno	INT IDENTITY NOT NULL,
nome		VARCHAR(100) NOT NULL
PRIMARY KEY(cod_aluno)
)
GO
CREATE TABLE atividade(
cod_atividade	INT IDENTITY NOT NULL,
descricao		VARCHAR(MAX) NOT NULL,
imc				DECIMAL(3,1) NOT NULL
PRIMARY KEY(cod_atividade)
)
GO
CREATE TABLE atividadesaluno(
cod_aluno	INT NOT NULL,
altura		DECIMAL(3,2) NOT NULL,
peso		DECIMAL(5,2) NOT NULL,
imc			DECIMAL(3,1) NOT NULL,
cod_atividade INT NOT NULL
PRIMARY KEY (cod_aluno, cod_atividade)
FOREIGN KEY (cod_aluno) REFERENCES aluno (cod_aluno),
FOREIGN KEY (cod_atividade) REFERENCES atividade (cod_atividade)
)

insert into atividade values
('Corrida + Step', 18.5),
('Biceps + Costas + Pernas',24.9),
('Esteira + Biceps + Costas + Pernas',29.9),
('Bicicleta + Biceps + Costas + Pernas',34.9),
('Esteira + Bicicleta',39.9) 

GO

CREATE PROCEDURE sp_buscaatividade(@imc DECIMAL(3,1), @cod_atividade INT OUTPUT)
AS
SET	@cod_atividade = (SELECT cod_atividade
from atividade
where imc = (SELECT MAX(imc)
FROM atividade
WHERE @imc >= imc
))

GO

CREATE PROCEDURE sp_alunoatividades(@cod_aluno INT, @nome VARCHAR(100), @altura DECIMAL(3,2), @peso DECIMAL(5,2), @saida VARCHAR(MAX) OUTPUT)
AS
DECLARE @imc DECIMAL(3,1)
DECLARE @cod_atividade INT
SET @imc = @peso / POWER(@altura,2) 

EXEC sp_buscaatividade @imc, @cod_atividade OUTPUT

IF(@cod_aluno = 0)
BEGIN
	INSERT INTO aluno VALUES
	(@nome)

	SET @cod_aluno =  SCOPE_IDENTITY()
	
	INSERT INTO atividadesaluno VALUES
	(@cod_aluno, @altura, @peso, @imc, @cod_atividade)

	SET @saida = 'Cadastrado com sucesso'
END
ELSE
BEGIN
	UPDATE atividadesaluno
	SET altura = @altura, peso = @peso, imc = @imc, cod_atividade = @cod_atividade
	WHERE cod_aluno = @cod_aluno

	SET @saida = 'Atualizado com sucesso'
END

GO

DECLARE @out VARCHAR(MAX)
EXEC sp_alunoatividades 0, 'kesia', 1.65 , 95.1, @out output
print @out

select * from atividadesaluno

select * from aluno