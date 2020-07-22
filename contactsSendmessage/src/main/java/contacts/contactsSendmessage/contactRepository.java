package contacts.contactsSendmessage;


import java.util.List;


import org.springframework.data.jpa.repository.JpaRepository;

public interface contactRepository extends JpaRepository<Contact, Integer>{

	List<Contact> findByName(String name);

}
