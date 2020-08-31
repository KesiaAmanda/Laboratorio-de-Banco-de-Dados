--2) Criar uma nova database e resolver o exercicio Aula_03a_-_Exercicio_Stored_Procedures.txt do site do professor.
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