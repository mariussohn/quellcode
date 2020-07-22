package contacts.contactsSendmessage;

import java.io.IOException;
import java.text.SimpleDateFormat;
import java.util.List;
import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.RestController;
import com.nexmo.client.NexmoClient;
import com.nexmo.client.sms.MessageStatus;
import com.nexmo.client.sms.SmsSubmissionResponse;
import com.nexmo.client.sms.SmsSubmissionResponseMessage;
import com.nexmo.client.sms.messages.TextMessage;





@RestController
public class contactResource {
	
	public String template;
	
	@Autowired
	private contactRepository contactRepository;
	

	
	@GetMapping("/{name}/{phone_number}/{customer_phone_number}/{template}")
	public String contactCustomer (@PathVariable("name") String name, @PathVariable("phone_number") String phone_number,
			@PathVariable("customer_phone_number") String customer_phone_number, @PathVariable("template") int template) throws Exception
	{
		int id=SQL_Connection.maxId();
		int id_number=id+1;
		String temp=SQL_Connection.findRightTemplate(name,template);
		customer_phone_number=validatePhoneNumber(customer_phone_number);
		String custom_uid= "whatsA"+id_number;
		open(phone_number,customer_phone_number,custom_uid,temp);
		String date=new SimpleDateFormat("yyyy.MM.dd - HH:mm:ss").format(new java.util.Date());
		SQL_Connection.SaveDataInDatabase(name,template,customer_phone_number,phone_number,date);
		id_number=id_number+1;
		return "ok";
	}
	@GetMapping("/contacts/{name}/{phone_number}/{customer_phone_number}/{text}")
	public String contactCustomerWithTemplate (@PathVariable("name") String name, @PathVariable("phone_number") String phone_number,
	@PathVariable("customer_phone_number") String customer_phone_number, @PathVariable("text") String text) throws Exception
	{
		int id=SQL_Connection.maxId();
		int id_number=id+1;
		template= text;
		int number=0;
		customer_phone_number=validatePhoneNumber(customer_phone_number);
		String custom_uid= "whatsA"+id_number;
		open(phone_number,customer_phone_number,custom_uid,template);
		String date=new SimpleDateFormat("yyyy.MM.dd - HH:mm:ss").format(new java.util.Date());
		SQL_Connection.SaveDataInDatabase(name, number ,customer_phone_number,phone_number,date);
		id_number=id_number+1;
		return "ok";
	}
			@GetMapping("/contacts/sms/{name}/{customer_phone_number}/{text}")
			public String sendSmsToCustomer(@PathVariable("name") String name,@PathVariable("customer_phone_number") String customer_phone_number, @PathVariable("text") String text) throws Exception
			{
			
		
			NexmoClient client = NexmoClient.builder().apiKey("0d385e9e").apiSecret("CKFHo8ZhP34rWlS7").build();
			
			SmsSubmissionResponse responses = client.getSmsClient().submitMessage(new TextMessage(
					name,
			        customer_phone_number,
			        text));
			for (SmsSubmissionResponseMessage response : responses.getMessages()) {
			    System.out.println (response);
			}
		
			if (responses.getMessages().get(0).getStatus() == MessageStatus.OK) {
				String date=new SimpleDateFormat("yyyy.MM.dd - HH:mm:ss").format(new java.util.Date());
					SQL_Connection.SaveDataInSmsDB(name, customer_phone_number, text,date);
					return "Message sent successfully.";
			    } else {
			        return "Message failed with error: " + responses.getMessages().get(0).getErrorText();
			    }
			}

	
	@GetMapping("/admin/contacts")
	public List<Contact> retrieveAllContacts()
	{
		return contactRepository.findAll();
	}
	@GetMapping("/admin/contacts/{name}")
	public List<Contact> retrieveAllContactsFromUser(@PathVariable String name)
	{
		return contactRepository.findByName(name);
	}

	
	public void open(String uid,String to, String custom_uid, String temp) {
		String uni_token="0af5070d29436de0e60fdad8fbb2d8f65df1ef819ce36";
	
		try {
			Runtime.getRuntime().exec(
					"rundll32 url.dll,FileProtocolHandler "
							+ "https://www.waboxapp.com/api/send/chat?token="+uni_token+"&uid="+uid+"&to="+to+"&custom_uid="+custom_uid+"&text="+temp);
		} catch (IOException e) {
			e.printStackTrace();
		}
	}
	public String validatePhoneNumber(String number)
	{
		number.replaceAll("[^\\d]+", "").replaceAll("^0+", "");
		return number;

	}
	

}
