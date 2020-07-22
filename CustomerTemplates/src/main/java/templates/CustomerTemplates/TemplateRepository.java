package templates.CustomerTemplates;


import java.util.List;

//import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;


public interface TemplateRepository extends CrudRepository<Template, Integer>{

	Template findByTemplateIdAndName(int template_id, String name);

	List<Template> findByName(String name);

	Template findByTemplateIdAndUsername(int template_id, String username);

	

}
