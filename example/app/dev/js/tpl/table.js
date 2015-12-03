define(["jade"],function(jade){

return function template(locals) {
var buf = [];
var jade_mixins = {};
var jade_interp;
;var locals_for_with = (locals || {});(function (arr1) {
buf.push("<div id=\"table\"><table><thead><tr> ");
for(var i=0; i< arr1.length;i++)
{
buf.push("<td>" + (jade.escape((jade_interp = arr1[i]) == null ? '' : jade_interp)) + "</td>");
}
buf.push("</tr></thead><tbody><tr></tr></tbody></table></div>");}.call(this,"arr1" in locals_for_with?locals_for_with.arr1:typeof arr1!=="undefined"?arr1:undefined));;return buf.join("");
};

});
