<?php
$i = 0;
$servname = "localhost";
$username = "user";
$passwd = "pass";
$dbname = "wordpress"

$conn = new mysqli($servname, $username, $passwd, $dbname);

if($conn->connect_error) {
  die("DERP");
}
while (i<150) {
$i = $i+1;
$title = "Pagina".i;
$text = "Lorem ipsum dolor sit amet, consectetur adipiscing elit. Donec quis eros vestibulum, finibus justo in, pellentesque velit. Integer ante arcu, commodo ultrices porta ut, pretium sed leo. Sed in nisl eget neque pretium sagittis sed et velit. Aenean tincidunt feugiat felis, quis suscipit ligula volutpat id. Sed lacinia diam justo. Sed auctor facilisis nunc, vitae posuere lacus condimentum ac. Mauris scelerisque ex eros, ut viverra neque interdum at. Etiam id magna nunc. Proin et est tortor. Aliquam imperdiet, lacus aliquam scelerisque congue, ex sem pretium urna, vel finibus lacus massa at ligula. Duis tempus nunc in elementum pulvinar.

Ut nec tortor vitae neque tempus tempor accumsan non felis. Fusce maximus turpis vel neque finibus, at iaculis purus mattis. Ut euismod ac elit sit amet ultricies. Nunc tempor ornare purus at scelerisque. Lorem ipsum dolor sit amet, consectetur adipiscing elit. Ut vel velit nulla. Etiam a mauris nunc. Praesent dapibus suscipit orci. Etiam vestibulum urna eget aliquet luctus. Phasellus eget sem nisl. Quisque eu auctor nisi, quis tincidunt metus. Curabitur a neque augue. Sed viverra, nisi a venenatis hendrerit, purus erat accumsan sem, et elementum elit lacus vitae erat. Morbi diam nunc, lobortis et massa id, vulputate mollis nunc.

In hac habitasse platea dictumst. Nunc ut eros orci. Mauris venenatis augue eget orci euismod, eu convallis odio pharetra. Donec consequat nunc ex, non hendrerit magna placerat a. Ut congue vel nisi consequat porta. Duis venenatis commodo nisi quis volutpat. Praesent viverra libero ultricies est hendrerit dapibus. Pellentesque libero nulla, tristique non tincidunt eget, luctus at magna. Etiam rhoncus vestibulum quam, at fringilla velit efficitur eu. Aenean suscipit lacinia mauris, ac hendrerit odio pellentesque et. Class aptent taciti sociosqu ad litora torquent per conubia nostra, per inceptos himenaeos. Cras venenatis pharetra arcu, a fringilla eros venenatis et. Proin ex felis, ultrices sit amet erat et, ullamcorper lobortis nulla. Fusce id semper dui. Quisque semper nisl eu tempor gravida.

Donec consequat lorem id augue iaculis, et sollicitudin nunc tincidunt. Donec mauris libero, rhoncus at risus non, pharetra volutpat nisi. Proin mollis sollicitudin consectetur. Aenean vel iaculis massa. Phasellus fermentum augue at sodales varius. Proin sollicitudin est nec pretium viverra. Vivamus posuere nibh eu nisl tristique hendrerit. Donec at lectus vitae odio consectetur malesuada at sed dui.

Aliquam iaculis ipsum ut nibh consequat, a bibendum nulla vestibulum. Maecenas id imperdiet sapien. Etiam mattis congue ante efficitur venenatis. Phasellus dignissim mi ullamcorper facilisis gravida. Sed in orci eget orci euismod dictum. Duis ac urna dignissim, dapibus odio ut, faucibus enim. Curabitur nulla nibh, suscipit a fringilla ac, laoreet sit amet ante. Donec luctus eleifend nunc quis tristique. Curabitur lobortis tempus sapien, eget dignissim tortor lobortis a. Etiam eget orci id lacus pellentesque tincidunt quis quis ligula.";
$sql = "INSERT INTO pagina(title, text) VALUES (".$title.", ".$text.");";

if($conn->query($sql) === TRUE) {
  echo "OKAY";
}
else {
   echo "DERPAHERP<br>".$conn->error;
}

}
$conn->close();
?>
