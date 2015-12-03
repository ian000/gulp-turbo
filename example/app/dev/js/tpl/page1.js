define(["jade"],function(jade){

return function template(locals) {
var buf = [];
var jade_mixins = {};
var jade_interp;
;var locals_for_with = (locals || {});(function ($CONFIG, arr1, wwwroot) {
buf.push("<div><p><span>" + (jade.escape((jade_interp = wwwroot) == null ? '' : jade_interp)) + "</span><em> " + (jade.escape((jade_interp = $CONFIG.data) == null ? '' : jade_interp)) + "</em></p><div>asdasd</div></div><div id=\"table\"><table><thead><tr> ");
for(var i=0; i< arr1.length;i++)
{
buf.push("<td>" + (jade.escape((jade_interp = arr1[i]) == null ? '' : jade_interp)) + "</td>");
}
buf.push("</tr></thead><tbody><tr></tr></tbody></table></div>");}.call(this,"$CONFIG" in locals_for_with?locals_for_with.$CONFIG:typeof $CONFIG!=="undefined"?$CONFIG:undefined,"arr1" in locals_for_with?locals_for_with.arr1:typeof arr1!=="undefined"?arr1:undefined,"wwwroot" in locals_for_with?locals_for_with.wwwroot:typeof wwwroot!=="undefined"?wwwroot:undefined));;return buf.join("");
};

});
