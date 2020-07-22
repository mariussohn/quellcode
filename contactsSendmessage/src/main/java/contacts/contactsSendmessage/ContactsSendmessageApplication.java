package contacts.contactsSendmessage;

import org.springframework.boot.SpringApplication;
import org.springframework.boot.autoconfigure.SpringBootApplication;
import org.springframework.cloud.netflix.eureka.EnableEurekaClient;



@SpringBootApplication
@EnableEurekaClient
public class ContactsSendmessageApplication {

	public static void main(String[] args) {
		SpringApplication.run(ContactsSendmessageApplication.class, args);
		
		
	}


}
