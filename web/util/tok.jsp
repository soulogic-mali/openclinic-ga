<html>
<body>
<!-- OpenTok.js library -->
<script src="https://static.opentok.com/v2/js/opentok.js"></script>
<script>

// credentials
var apiKey = '45828062';
var sessionId = '1_MX40NTgyODA2Mn5-MTU4ODcxNzY5NDc2Nn5tZGRHOG5PVmhTSmpWdnh1N1VUZURjZnZ-UH4';
var token = 'T1==cGFydG5lcl9pZD00NTgyODA2MiZzaWc9ZjNlN2U4OGM4NTA4YTcxOTE3YzRjNGU0MmRmNWEwYzE2Y2JlN2U3OTpzZXNzaW9uX2lkPTFfTVg0ME5UZ3lPREEyTW41LU1UVTRPRGN4TnpZNU5EYzJObjV0WkdSSE9HNVBWbWhUU21wV2RuaDFOMVZVWlVSalpuWi1VSDQmY3JlYXRlX3RpbWU9MTU4ODcxNzcxMyZub25jZT0wLjA4ODQ2Nzc2NTA0MDU3MDc0JnJvbGU9cHVibGlzaGVyJmV4cGlyZV90aW1lPTE1ODg4MDQxMTM=';

// connect to session
var session = OT.initSession(apiKey, sessionId);

// create publisher
var publisher = OT.initPublisher();
session.connect(token, function(err) {
   // publish publisher
	session.publish(publisher);
});
  
// create subscriber
session.on('streamCreated', function(event) {
   session.subscribe(event.stream);
});

</script>
</body>
</html>