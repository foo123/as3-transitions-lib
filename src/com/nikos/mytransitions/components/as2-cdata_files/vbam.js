vbam_ajax=new Array();vbax=new vB_AJAX_Handler(true);function cstmGetElementsByClassName(E){var A=document.all||document.getElementsByTagName("*");var C=new RegExp("(?:^|\\s)"+E+"(?:\\s|$)");var D=new Array();for(var B=0;B<A.length;B++){if(C.test(A[B].className)){D[D.length]=A[B]}}return D}function recreatead(H,D,B,G){if(H==""||D==""||vbam_ajax[H]===false){return false}var E=H+"_adcode";var F=cstmGetElementsByClassName(E);if(B=="true"){for(var C=0;C<F.length;C++){if(F[C].innerHTML==""){return false}}}else{if(fetch_object(E).innerHTML==""){return false}}if(G==""){G=H}vbax.onreadystatechange(A);vbax.send(D+"?do=createad&adcode="+H+"&setting="+G+"&securitytoken="+SECURITYTOKEN);function A(){if(vbax.handler.readyState==4&&vbax.handler.status==200){if(vbax.handler.responseText!=""){if(B=="true"){for(var I=0;I<F.length;I++){F[I].innerHTML=vbax.handler.responseText}}else{fetch_object(E).innerHTML=vbax.handler.responseText}return }}vbam_ajax[H]=false}};