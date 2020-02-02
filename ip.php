<?php
if(strpos($_SERVER['HTTP_USER_AGENT'], 'curl') === False){
    echo <<< EOF
<html>

<head>
    <style>
    #main {
        position: fixed;
        top: 50%;
        left: 50%;
        transform: translate(-50%, -50%);
        font-size: 128px;
    }
    </style>
</head>

<body>
    <div id="main">
        <b>${_SERVER['REMOTE_ADDR']}</b>
    </div>
</body>

</html>
EOF;
} else {
    echo $_SERVER['REMOTE_ADDR']."\n";
}
?>
