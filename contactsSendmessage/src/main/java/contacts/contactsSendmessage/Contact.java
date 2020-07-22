package contacts.contactsSendmessage;

import javax.persistence.Entity;
import javax.persistence.GeneratedValue;
import javax.persistence.GenerationType;
import javax.persistence.Id;
import javax.persistence.Table;

@Entity
@Table(name= "Contact")
public class Contact {
		
		@Id
		@GeneratedValue(strategy = GenerationType.AUTO)
		private int contact_id;
		
		private String name;
		private String phone_number;
		private String customer_phone_number;
		private int template;
		private String timeStamp;
		
		public int getContact_id() {
			return contact_id;
		}
		public void setContact_id(int contact_id) {
			this.contact_id = contact_id;
		}
		public String getPhone_number() {
			return phone_number;
		}
		public void setPhone_number(String phone_number) {
			this.phone_number = phone_number;
		}
		public String getCustomer_phone_number() {
			return customer_phone_number;
		}
		public void setCustomer_phone_number(String customer_phone_number) {
			this.customer_phone_number = customer_phone_number;
		}
		
		public int getTemplate() {
			return template;
		}
		public void setTemplate(int template) {
			this.template = template;
		}
		
		public String getName() {
			return name;
		}
		public void setName(String name) {
			this.name = name;
		}
		
		public String getTimeStamp() {
			return timeStamp;
		}
		public void setTimeStamp(String timeStamp) {
			this.timeStamp = timeStamp;
		}
		public Contact()
		{
			
		}
		public Contact(int contact_id,String name, String phone_number, String customer_phone_number,  int template) {
			super();
			
			this.contact_id = contact_id;
			this.name=name;
			this.phone_number = phone_number;
			this.customer_phone_number = customer_phone_number;
			
			this.template = template;
		}
		

	}
