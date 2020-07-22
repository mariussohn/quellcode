package templates.CustomerTemplates;

import javax.persistence.Column;
import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name= "templates")
public class Template {
	@Id
	@GeneratedValue(strategy = GenerationType.AUTO)
	private int id;
	private String username;
	private String template;
	@Column(name="name")
	private String name;
	@Column(name="template_id")
	private int templateId;
	
	
	public int getId() {
		return id;
	}
	public void setId(int id) {
		this.id = id;
	}
	public String getTemplate() {
		return template;
	}
	public void setTemplate(String template) {
		this.template = template;
	}
	public String getName() {
		return name;
	}

	public int getTemplateId() {
		return templateId;
	}
	public void setTemplateId(int templateId) {
		this.templateId = templateId;
	}
	public String getUsername() {
		return username;
	}
	public void setUsername(String username) {
		this.username = username;
	}
	public void setName(String name) {
		this.name = name;
	}
	public Template( String template, String name, int templateId, String username) {
		super();
		this.username=username;
		this.template = template;
		this.name = name;
		this.templateId = templateId;
	}
	public Template() {
		
	}
}
