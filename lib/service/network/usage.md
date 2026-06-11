`final api = ApiService.instance;

// GET
final data = await api.get('users/profile');

//` POST
final res = await api.post('auth/login', {'email': email, 'password': pass});

// Upload
await api.upload('users/avatar', fields: {'userId': '123'}, files: [imageFile]);
