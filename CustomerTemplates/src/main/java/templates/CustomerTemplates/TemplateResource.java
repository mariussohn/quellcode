package templates.CustomerTemplates;


import java.util.List;

import org.springframework.beans.factory.annotation.Autowired;

import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PatchMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RestController;



@RestController
public class TemplateResource {
	
	@Autowired
	private TemplateRepository templateRepository;
	@Autowired
	private TemplateService templateService;
	
	@GetMapping("/admin/templates")
	public Iterable<Template> retrieveAllTemplates()
	{
		return templateRepository.findAll();
	}
	@GetMapping("/templates/{name}")
	public List<Template> retrieveTemplateByName(@PathVariable("name") String name)
	{
		  return templateRepository.findByName(name);	
	}
	@PatchMapping("/templates/{name}/{template_id}")
	public Template updateTemplate(@PathVariable("name") String name, 
	                               @PathVariable("template_id") int template_id, 
	                               @RequestBody Template template)  {
	    return templateService.updateTemplate(template_id,name, template);
	}
	
	@GetMapping("/templates/{name}/{template_id}")
	public Template retrieveTemplate(@PathVariable("name") String name,@PathVariable("template_id") int template_id)
	{
		return templateRepository.findByTemplateIdAndName(template_id, name);

	}
	@DeleteMapping("/templates/{name}/{template_id}")
	public void deleteUser(@PathVariable("name") String name, 
            @PathVariable("template_id") int template_id)
	{
		SQL_Connection.deleteTemplate(name, template_id);
	}
	
	@PostMapping("/templates")
	public void insertTemplate(@RequestBody Template template)
	{
		
		SQL_Connection.insertTemplate(template.getTemplate(), template.getName(), template.getTemplateId(), template.getUsername());
		
		
	}
	
}
