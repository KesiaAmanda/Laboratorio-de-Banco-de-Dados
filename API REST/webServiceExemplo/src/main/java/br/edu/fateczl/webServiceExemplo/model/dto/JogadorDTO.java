package br.edu.fateczl.webServiceExemplo.model.dto;

public class JogadorDTO {
    private int codigo;
    private String nomeJogador;
    private String sexo;
    private float altura;
    private String dt_nasc;
    private int idade;
    private TimesDTO time;

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

    public int getIdade() {
        return idade;
    }

    public void setIdade(int idade) {
        this.idade = idade;
    }

    public TimesDTO getTime() {
        return time;
    }

    public void setTime(TimesDTO time) {
        this.time = time;
    }

}
