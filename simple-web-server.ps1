$http=[System.Net.HttpListener]::new() 
$http.Prefixes.Add("http://127.0.0.1:54321/")
$http.Start()


while ($http.IsListening) {
    $context = $http.GetContext()

    if ($context.Request.HttpMethod -eq 'GET') {
	    $rq_path=$context.Request.Url.AbsolutePath.Replace("/","\") 
	    $curr_dir=[System.Environment]::CurrentDirectory
	    write-host "$($curr_dir + $rq_path)" -f 'mag'
	    $buffer=[System.IO.File]::ReadAllBytes($curr_dir + $rq_path) 
	    $context.Response.ContentLength64 = $buffer.Length
	    $context.Response.OutputStream.Write($buffer, 0, $buffer.Length) #stream to broswer
	    $context.Response.OutputStream.Close() # close the response
    }

    if ($context.Request.HttpMethod -eq 'DELETE') {
	    break
    }
} 

