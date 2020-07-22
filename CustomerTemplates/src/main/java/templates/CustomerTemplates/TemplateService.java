package templates.CustomerTemplates;

import javax.transaction.Transactional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.stereotype.Service;

@Service
public class TemplateService {

    @Autowired
    private TemplateRepository templateRepository;

    @Transactional
    public Template updateTemplate(int template_id, String name, Template updateTemplate) {
        Template foundTemplate = templateRepository.findByTemplateIdAndName(template_id, name);
        foundTemplate.setTemplate(updateTemplate.getTemplate());
        return foundTemplate;
    }

	
}