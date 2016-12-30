# LightSocket

### About
LightSocket is a simple and lightweight tcp socket library built in objective-c with the socket POSIX api.

### How it works
LightSocket was built in order to share a maximum of data per single connection unlike the http protocol based on "one request - one response".
LightSocket is stream and message oriented. It means that instructions called "messages" will continuously be written by the client. LightSocket server will treat each delimited message independently.


#### Configuration

__Message delimiter__

You can choose a single character message delimiter by editing `END_OF_MSG` value defined in LightSocket.h. By default the delimiter is new line feed symbol aka `\n`.
``` objective-c
#define END_OF_MSG '\n'
```
Since LightSocket works with stream, you don't have to carry about the buffer size overflow. The socket server will read until he finds the next delimiter even if the buffer size is smaller than the written message.

__On Message Action__

As said above, each message is treated by LightSocket. Each time a message is got by LightSocket, it will call the `- (void)onMessageAction:(NSString *)message` method, where of course, `message` is the message without delimiter.
To perform the task you want you can edit this method.

``` objective-c
- (void)onMessageAction:(NSString *)message
{
    // your stuff here...
}
```


#### Start a server

It is very simple to start a new server. Let start a new listening server on port 5632 :

``` objective-c
LightSocket *server = [[LightSocket alloc] initWithPort:5632];
[server startServer];
```

Since `startServer` method returns a boolean, you can write something like :

``` objective-c
LightSocket *server = [[LightSocket alloc] initWithPort:5632];
if ([server startServer])
{
  NSLog("YEAH :)");
}
else
{
  NSLog("OUCH :(")
}
```

#### Send a message

Read messages is an important thing, but like in real life, unilateral conversations are not so exciting...
You can easily send a message using the `- (void)sendMessage:(NSString *)message` method :

``` objective-c
- (void)onMessageAction:(NSString *)message
{
    [self sendMessage:[NSString stringWithFormat:@"I got your message: %@", message]];
}
```
