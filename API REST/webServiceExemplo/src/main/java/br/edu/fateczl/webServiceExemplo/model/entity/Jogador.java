package br.edu.fateczl.webServiceExemplo.model.entity;

import javax.persistence.*;

@Entity
@Table(name = "jogador")
@NamedNativeQuery(
        name = "Jogador.findJogadoresDataConv",
        query = "SELECT j.codigo, j.nomeJogador, j.sexo, j.altura, " +
                "CONVERT(CHAR(10), j.dt_nasc, 103) AS dt_nasc, j.id_time, " +
                "t.ID, t.nome, t.cidade " +
                "FROM jogador j INNER JOIN times t " +
                "ON j.id_time = t.ID",
        resultClass = Jogador.class
)
@NamedNativeQuery(
        name = "Jogador.findJogadorDataConv",
        query = "SELECT j.codigo, j.nomeJogador, j.sexo, j.altura, " +
                "CONVERT(CHAR(10), j.dt_nasc, 103) AS dt_nasc, j.id_time, " +
                "t.ID, t.nome, t.cidade " +
                "FROM jogador j INNER JOIN times t " +
                "ON j.id_time = t.ID " +
                "AND j.codigo = ?1",
        resultClass = Jogador.class
)
public class Jogador {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
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
    @ManyToOne(targetEntity = Times.class)
    @JoinColumn(name = "id_time")
    private Times time;

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

    public Times getTime() {
        return time;
    }

    public void setTime(Times time) {
        this.time = time;
    }

    @Override
    public String toString() {
        return "Jogador{" +
                "codigo=" + codigo +
                ", nomeJogador='" + nomeJogador + '\'' +
                ", sexo='" + sexo + '\'' +
                ", altura=" + altura +
                ", dt_nasc='" + dt_nasc + '\'' +
                ", time=" + time +
                '}';
    }
}
