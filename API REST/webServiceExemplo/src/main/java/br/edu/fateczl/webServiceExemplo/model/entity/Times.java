package br.edu.fateczl.webServiceExemplo.model.entity;

import javax.persistence.*;

@Entity
@Table(name = "times")
@NamedStoredProcedureQuery(
        name = "Times.spCrudTimes",
        procedureName = "sp_crudTimes",
        parameters = {
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "cod", type = String.class),
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "id", type = Integer.class),
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "nome", type = String.class),
                @StoredProcedureParameter(mode = ParameterMode.IN, name = "cidade", type = String.class),
                @StoredProcedureParameter(mode = ParameterMode.OUT, name = "saida", type = String.class)
        }
)
public class Times {
    @Id
    @GeneratedValue(strategy = GenerationType.IDENTITY)
    @Column
    private int id;
    @Column
    private String nome;
    @Column
    private String cidade;
    @Transient
    private String cod;
    @Transient
    private String saida;

    public String getCod() {
        return cod;
    }

    public void setCod(String cod) {
        this.cod = cod;
    }

    public String getSaida() {
        return saida;
    }

    public void setSaida(String saida) {
        this.saida = saida;
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

    @Override
    public String toString() {
        return "Times{" +
                "id=" + id +
                ", nome='" + nome + '\'' +
                ", cidade='" + cidade + '\'' +
                '}';
    }
}
