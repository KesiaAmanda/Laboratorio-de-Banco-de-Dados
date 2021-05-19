package br.edu.fateczl.webServiceExemplo.model.dto;

public class TimesDTO {
    private int id;
    private String nome;
    private String cidade;
    private String saida;

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

    public String getSaida() {
        return saida;
    }

    public void setSaida(String saida) {
        this.saida = saida;
    }

    @Override
    public String toString() {
        return "TimesDTO{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                ", cidade='" + cidade + '\'' +
                ", saida='" + saida + '\'' +
                '}';
    }
}
