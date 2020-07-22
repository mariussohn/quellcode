package sendMessage.ApiGateway;

import java.util.List;
import java.util.Optional;

import org.springframework.data.jpa.repository.JpaRepository;
import org.springframework.data.repository.CrudRepository;



public interface UserRepository extends JpaRepository<User, Integer>{

	Optional<User> findByName(String name);

	void deleteByName(String name);

	Optional<User> findByUsername(String userName);

	
}
