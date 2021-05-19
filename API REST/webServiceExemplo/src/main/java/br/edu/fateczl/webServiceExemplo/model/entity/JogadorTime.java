package br.edu.fateczl.webServiceExemplo.model.entity;

import javax.persistence.*;

@Entity
@Table(name = "jogadorTime")
@NamedNativeQuery(
        name = "JogadorTime.udfJogadorIdade",
        query = "SELECT codigo, nomeJogador, sexo, altura, dt_nasc, idade, id, nome, cidade "+
                "FROM fn_jogadorIdade(?1)",
        resultClass = JogadorTime.class
)
public class JogadorTime {
    @Id
    @Column
    private int codigo;
    @Column
    private String nomeJogador;
    @Column
    private String sexo;
    @Column
    private float altura;
    @Column
    private String dt_nasc;
    @Column
    private int idade;
    @Column
    private int id;
    @Column
    private String nome;
    @Column
    private String cidade;

    public int getIdade() {
        return idade;
    }

    public void setIdade(int idade) {
        this.idade = idade;
    }

    public int getId() {
        return id;
    }

    public void setId(int id) {
        this.id = id;
    }

    public String getNome() {
        return nome;
    }

    public void setNome(String nome) {
        this.nome = nome;
    }

    public String getCidade() {
        return cidade;
    }

    public void setCidade(String cidade) {
        this.cidade = cidade;
    }

    public int getCodigo() {
        return codigo;
    }

    public void setCodigo(int codigo) {
        this.codigo = codigo;
    }

    public String getNomeJogador() {
        return nomeJogador;
    }

    public void setNomeJogador(String nomeJogador) {
        this.nomeJogador = nomeJogador;
    }

    public String getSexo() {
        return sexo;
    }

    public void setSexo(String sexo) {
        this.sexo = sexo;
    }

    public float getAltura() {
        return altura;
    }

    public void setAltura(float altura) {
        this.altura = altura;
    }

    public String getDt_nasc() {
        return dt_nasc;
    }

    public void setDt_nasc(String dt_nasc) {
        this.dt_nasc = dt_nasc;
    }

    @Override
    public String toString() {
        return "JogadorTime{" +
                "codigo=" + codigo +
                ", nomeJogador='" + nomeJogador + '\'' +
                ", sexo='" + sexo + '\'' +
                ", altura=" + altura +
                ", dt_nasc='" + dt_nasc + '\'' +
                ", idade=" + idade +
                ", id=" + id +
                ", nome='" + nome + '\'' +
                ", cidade='" + cidade + '\'' +
                '}';
    }
}
