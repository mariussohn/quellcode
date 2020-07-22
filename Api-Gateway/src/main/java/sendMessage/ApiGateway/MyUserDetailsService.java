package sendMessage.ApiGateway;

import java.util.Optional;

import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.core.userdetails.UserDetailsService;
import org.springframework.security.core.userdetails.UsernameNotFoundException;
import org.springframework.stereotype.Service;



@Service
public class MyUserDetailsService implements UserDetailsService{

	@Autowired
	UserRepository userRepository;
	
	@Override
	public UserDetails loadUserByUsername(String userName) throws UsernameNotFoundException 
	{
		Optional<sendMessage.ApiGateway.User> user=userRepository.findByUsername(userName);
		
		user.orElseThrow(() -> new UsernameNotFoundException("Not found:" + userName));
		
		return user.map(MyUserDetails::new).get();
	}
	
	
}
