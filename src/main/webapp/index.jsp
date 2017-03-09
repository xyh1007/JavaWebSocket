<%@ page language="java" pageEncoding="UTF-8" %>
<!DOCTYPE html>
<html>
<head>
    <title>Free Talk</title>
</head>
<body>
   <center>Free Talk</center> 
   <br/><center><textarea id="text" rows="3" cols="20"></textarea></center>
   <!--  <button onclick="send()" alt="按住ctrl+enter">发送消息</button> -->
    <hr/>
    <center>
    <input type="button" value="发送消息" title="按住ctrl+enter"  onclick="send()"></input>
    <button onclick="closeOropenWebSocket()" id="co" value="离开">离开</button>
    <button onclick=" clearall() ">清屏</button>
    </center>
    <hr/>
    <div id="message" style="width:1350px;overflow:auto;position:absolute;top:150px; bottom:0;" ></div>
</body>

<script type="text/javascript">
    var websocket = null;
    var host =window.location.host;
    var co =document.getElementById('co').value;
    document.onkeydown = function()  
    {  
        var oEvent = window.event;  
        if (oEvent.keyCode == 13 && oEvent.ctrlKey) {  
           send();
        }  
    } 
    //判断当前浏览器是否支持WebSocket
    if ('WebSocket' in window) {
        websocket = new WebSocket("ws:"+host+"/JavaWebSocket/websocket");
    }
    else {
        alert('当前浏览器 Not support websocket')
    }

    //连接发生错误的回调方法
    websocket.onerror = function () {
        setMessageInnerHTML("WebSocket连接发生错误");
    };

    //连接成功建立的回调方法
    websocket.onopen = function () {
        /* setMessageInnerHTML("WebSocket连接成功"); */
        alert("欢迎进入Free Talk");
    }

    //接收到消息的回调方法
    websocket.onmessage = function (event) {
        setMessageInnerHTML(event.data);
    }

    //连接关闭的回调方法
    websocket.onclose = function () {
       /*  setMessageInnerHTML("WebSocket连接关闭"); */
        alert("你已经离开了Free Talk");
    }

    //监听窗口关闭事件，当窗口关闭时，主动去关闭websocket连接，防止连接还没断开就关闭窗口，server端会抛异常。
    window.onbeforeunload = function () {
        closeWebSocket();
    }

    //将消息显示在网页上
    function setMessageInnerHTML(innerHTML) {
        document.getElementById('message').innerHTML += innerHTML +'</br>'+ "-----------------" + '<br/>';
    }
    //
    function closeOropenWebSocket() {
    	if(document.getElementById('co').value=="离开"){
    		document.getElementById('co').value="进入";
    		document.getElementById('co').innerHTML="进入";
    		closeWebSocket();
    	}else{
    		document.getElementById('co').value="离开";
    		document.getElementById('co').innerHTML="离开";
    		location.reload();
    	}
    }

    //关闭WebSocket连接
    function closeWebSocket() {
        websocket.close();
    }

    //发送消息
    function send() {
        var message = document.getElementById('text').value;
        websocket.send(message);
    }
    //清屏
    function clearall() {
    	document.getElementById('message').innerHTML=''; 
    } 
</script>

</html>