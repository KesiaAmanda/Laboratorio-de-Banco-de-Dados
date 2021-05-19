package br.edu.fateczl.webServiceExemplo.controller;

import br.edu.fateczl.webServiceExemplo.model.dto.TimesDTO;
import br.edu.fateczl.webServiceExemplo.model.entity.Times;
import br.edu.fateczl.webServiceExemplo.repository.TimesRepository;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.data.rest.webmvc.ResourceNotFoundException;
import org.springframework.http.ResponseEntity;
import org.springframework.web.bind.annotation.*;

import javax.validation.Valid;
import java.util.ArrayList;
import java.util.List;

@RestController
@RequestMapping("/api")
public class TimesController {
    @Autowired
    private TimesRepository timesRepository;

    @GetMapping("/times")
    public List<TimesDTO> getAllTimes(){
        return converteListaTimes(timesRepository.findAll());
    }

    @GetMapping("/times/{idTime}")
    public ResponseEntity<TimesDTO> getTime(@PathVariable(value = "idTime") int idTime)
                                    throws ResourceNotFoundException {
        Times time = timesRepository.findById(idTime).orElseThrow(
                () -> new ResourceNotFoundException(idTime +" inválido!")
        );
        return ResponseEntity.ok().body(converteTime(time));
    }

    @PostMapping("/times")
    public ResponseEntity<String> crudTimes (@Valid @RequestBody Times t){
        String saida = timesRepository.spCrudTimes(t.getCod(), t.getId(), t.getNome(), t.getCidade());
        return ResponseEntity.ok().body(saida);
    }

    private TimesDTO converteTime(Times time){
        TimesDTO timesDTO = new TimesDTO();

        timesDTO.setId(time.getId());
        timesDTO.setNome(time.getNome());
        timesDTO.setCidade(time.getCidade());

        return timesDTO;
    }

    private List<TimesDTO> converteListaTimes(List<Times> listaTimes){
        List<TimesDTO> timesDTOS = new ArrayList<TimesDTO>();
        for (Times t : listaTimes){
            TimesDTO timesDTO = new TimesDTO();
            timesDTO.setId(t.getId());
            timesDTO.setNome(t.getNome());
            timesDTO.setCidade(t.getCidade());

            timesDTOS.add(timesDTO);
        }

        return timesDTOS;
    }
}
