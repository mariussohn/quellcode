package templates.CustomerTemplates;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;


@SpringBootApplication
@EnableEurekaClient
public class CustomerTemplatesApplication {

	public static void main(String[] args) {
		SpringApplication.run(CustomerTemplatesApplication.class, args);
	}

}
