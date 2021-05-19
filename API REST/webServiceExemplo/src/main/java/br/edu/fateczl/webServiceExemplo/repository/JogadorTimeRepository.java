package br.edu.fateczl.webServiceExemplo.repository;

import br.edu.fateczl.webServiceExemplo.model.entity.JogadorTime;
import org.springframework.data.jpa.repository.JpaRepository;

public interface JogadorTimeRepository extends JpaRepository<JogadorTime, Integer> {
    JogadorTime udfJogadorIdade(int codigo);
}
