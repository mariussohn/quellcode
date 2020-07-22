package sendMessage.ApiGateway;

import java.net.URI;
import java.security.SecureRandom;
import java.util.Optional;
import java.util.Random;

import javax.transaction.Transactional;


import org.springframework.beans.factory.annotation.Autowired;
import org.springframework.http.ResponseEntity;
import org.springframework.security.authentication.AuthenticationManager;
import org.springframework.security.authentication.BadCredentialsException;
import org.springframework.security.authentication.UsernamePasswordAuthenticationToken;
import org.springframework.security.core.userdetails.UserDetails;
import org.springframework.security.crypto.bcrypt.BCryptPasswordEncoder;
import org.springframework.web.bind.annotation.DeleteMapping;
import org.springframework.web.bind.annotation.GetMapping;
import org.springframework.web.bind.annotation.PathVariable;
import org.springframework.web.bind.annotation.PostMapping;
import org.springframework.web.bind.annotation.PutMapping;
import org.springframework.web.bind.annotation.RequestBody;
import org.springframework.web.bind.annotation.RequestMapping;
import org.springframework.web.bind.annotation.RequestMethod;
import org.springframework.web.bind.annotation.RestController;
import org.springframework.web.servlet.support.ServletUriComponentsBuilder;

import javassist.NotFoundException;



@RestController
public class UserResource {
	
	@Autowired
	private UserRepository userRepository;
	
	@Autowired
	private MyUserDetailsService userDetailsService;
	
	@Autowired
	private JwtUtil jwtTokenUtil;
	
	@Autowired
	private AuthenticationManager authenticationManager;
	
	@Autowired
	private BCryptPasswordEncoder bCryptpasswordEncoder;
	
	@RequestMapping(value="/authenticate", method=RequestMethod.POST)
	public ResponseEntity<?> createAuthenticationToken(@RequestBody AuthenticationRequest authenticationRequest) throws Exception
	{
		
		try {
		authenticationManager.authenticate(new UsernamePasswordAuthenticationToken(authenticationRequest
				.getUsername(),authenticationRequest.getPassword()));
		}
		catch (BadCredentialsException e)
		{
			throw new Exception("Incorrect username or password",e);
		}
		final UserDetails userDetails = userDetailsService
				.loadUserByUsername(authenticationRequest.getUsername());
		final String jwt =jwtTokenUtil.generateToken(userDetails);
		
		return ResponseEntity.ok(new AuthenticationResponse(jwt));
		
	}
	@GetMapping("/admin/users")
	public Iterable<User> retrieveAllTemplates()
	{
		return userRepository.findAll();
	}
	@GetMapping("/admin/users/{name}")
	public Optional<User> retrieveUser(@PathVariable String name)
	{
		Optional<User> user = userRepository.findByName(name);
		
		return user;
	}
	@Transactional
	@DeleteMapping("/admin/users/{name}")
	public void deleteUser(@PathVariable String name)
	{
		userRepository.deleteByName(name);
	}
	@PostMapping("/admin/users")
	public String createUser (@RequestBody User user) throws Exception
	{
		String password =user.getPassword(); //generatePassword(10);
		password=bCryptpasswordEncoder.encode(password);
		String username=generatePassword(16);
		user.setUsername(username);
		user.setPassword(password);
		
		SQL_Connection.SaveUser(true, user.getName(), password, user.getRoles(), username);
		
		return "ok";
	}
	 @PutMapping("/admin/users/putname/{name}")
	    public ResponseEntity<User> updateUser(
	    @PathVariable(value = "name") String name,
	    @RequestBody User userDetails) throws NotFoundException {
	         User user = userRepository.findByName(name)
	          .orElseThrow(() -> new NotFoundException("User not found on :: "+ name));
	  
	        user.setName(userDetails.getName());
	        
	        
	        final User updatedUser = userRepository.save(user);
	        return ResponseEntity.ok(updatedUser);
	 	}
	 @PutMapping("/admin/users/putactivity/{name}")
	    public ResponseEntity<User> updateActivity(
	    @PathVariable(value = "name") String name,
	    @RequestBody User userDetails) throws NotFoundException {
	         User user = userRepository.findByName(name)
	          .orElseThrow(() -> new NotFoundException("User not found on :: "+ name));
	  
	         user.setActive(userDetails.isActive());
	        
	        
	        final User updatedUser = userRepository.save(user);
	        return ResponseEntity.ok(updatedUser);
	 	}
	 
	 
	 private static final Random RANDOM = new SecureRandom();
	 private static final String ALPHABET = "0123456789ABCDEFGHIJKLMNOPQRSTUVWXYZabcdefghijklmnopqrstuvwxyz";
	 
	 public static String generatePassword(int length) {
	        StringBuilder returnValue = new StringBuilder(length);
	        for (int i = 0; i < length; i++) {
	            returnValue.append(ALPHABET.charAt(RANDOM.nextInt(ALPHABET.length())));
	        }
	        return new String(returnValue);
	    }
	 
	
}