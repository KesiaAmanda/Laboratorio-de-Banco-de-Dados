package br.edu.fateczl.webServiceExemplo.controller;

import br.edu.fateczl.webServiceExemplo.model.dto.JogadorDTO;
import br.edu.fateczl.webServiceExemplo.model.dto.TimesDTO;
import br.edu.fateczl.webServiceExemplo.model.entity.Jogador;
import br.edu.fateczl.webServiceExemplo.repository.JogadorRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api")
public class JogadorController {
    @Autowired
    private JogadorRepository jogadorRepository;

    @GetMapping("/jogador")
    public List<JogadorDTO> getAllJogador(){
    	List<Jogador> jogadores = jogadorRepository.findJogadoresDataConv();
    	List<JogadorDTO> jogadorDTOs = converteListaJogador(jogadores);
        return jogadorDTOs;
    }

    @GetMapping("/jogador/{codigo}")
    public ResponseEntity<JogadorDTO> getJogador(@PathVariable(value = "codigo") int codigo){
    	Jogador jogador = jogadorRepository.findJogadorDataConv(codigo);
    	JogadorDTO jogadorDTO = converteJogador(jogador);
        return ResponseEntity.ok().body(jogadorDTO);
    }

    @PostMapping("/jogador")
    public ResponseEntity<String> insereJogador(@Valid @RequestBody Jogador j){
        jogadorRepository.save(j);
        return ResponseEntity.ok().body("ok");
    }

    @PutMapping("/jogador")
    public ResponseEntity<String> updateJogador(@Valid @RequestBody Jogador j){
        jogadorRepository.save(j);
        return ResponseEntity.ok().body("atualizado");
    }

    @DeleteMapping("/jogador")
    public ResponseEntity<String> deleteJogador(@Valid @RequestBody Jogador j){
        jogadorRepository.delete(j);
        return ResponseEntity.ok().body("removido");
    }

    private JogadorDTO converteJogador(Jogador j){
        JogadorDTO jDTO = new JogadorDTO();
        
        jDTO.setCodigo(j.getCodigo());
        jDTO.setNomeJogador(j.getNomeJogador());
        jDTO.setSexo(j.getSexo());
        jDTO.setAltura(j.getAltura());
        jDTO.setDt_nasc(j.getDt_nasc());

        TimesDTO tDTO = new TimesDTO();
        tDTO.setId(j.getTime().getId());
        tDTO.setNome(j.getTime().getNome());
        tDTO.setCidade(j.getTime().getCidade());

        jDTO.setTime(tDTO);

        return jDTO;
    }

    private List<JogadorDTO> converteListaJogador(List<Jogador> jogadores){
        List<JogadorDTO> jogadorDTOS = new ArrayList<JogadorDTO>();

        for(Jogador j : jogadores){
            JogadorDTO jDTO = new JogadorDTO();
            jDTO.setCodigo(j.getCodigo());
            jDTO.setNomeJogador(j.getNomeJogador());
            jDTO.setSexo(j.getSexo());
            jDTO.setAltura(j.getAltura());
            jDTO.setDt_nasc(j.getDt_nasc());

            TimesDTO tDTO = new TimesDTO();
            tDTO.setId(j.getTime().getId());
            tDTO.setNome(j.getTime().getNome());
            tDTO.setCidade(j.getTime().getCidade());

            jDTO.setTime(tDTO);

            jogadorDTOS.add(jDTO);
        }
        return jogadorDTOS;
    }
}
