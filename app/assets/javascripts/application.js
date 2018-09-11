// This is a manifest file that'll be compiled into application.js, which will include all the files
// listed below.
//
// Any JavaScript/Coffee file within this directory, lib/assets/javascripts, or any plugin's
// vendor/assets/javascripts directory can be referenced here using a relative path.
//
// It's not advisable to add code directly here, but if you do, it'll appear at the bottom of the
// compiled file. JavaScript code in this file should be added after the last require_* statement.
//
// Read Sprockets README (https://github.com/rails/sprockets#sprockets-directives) for details
// about supported directives.
//
//= require rails-ujs
//= require activestorage
//= require turbolinks
//= require jquery3
//= require jquery-ui
//= require_tree .

$(document).ready(function(){
  // $(".datepicker" ).datepicker({ dateFormat: 'yy-mm-dd' });
  $('.datepicker').on("change", function(){
    console.log($(this).val())
    console.log(Date.parse($(this).val()))
  });
});

$(document).on('click', '.close', function(e){
  e.preventDefault();
  this.closest('.card').remove();
})

$(document).on('click', '.add-parent', function(e){
  e.preventDefault();
  console.log(this)
  cloneTemplate('parent-template')
})

$(document).on('click', '.add-child', function(e){
  e.preventDefault();
  cloneTemplate('child-template')
})


window.addEventListener('load', function() {
  // Fetch all the forms we want to apply custom Bootstrap validation styles to
  var forms = document.getElementsByClassName('needs-validation');
  // Loop over them and prevent submission
  var validation = Array.prototype.filter.call(forms, function(form) {
    form.addEventListener('submit', function(event) {
      if (form.checkValidity() === false) {
        event.preventDefault();
        event.stopPropagation();
      }
      form.classList.add('was-validated');
    }, false);
  });
}, false);

function cloneTemplate(templateName){
  var membersContainer = document.getElementsByClassName('members')[0];
  htmlContent = document.getElementById(templateName)
  switch(templateName) {
  case "child-template":
    newValue = parseInt(membersContainer.attributes["data-child-count"].value) + 1;
    membersContainer.attributes["data-child-count"].value = newValue
    htmlContent = htmlContent.innerHTML.replace(/timestamp/g, newValue)
    htmlContent = htmlContent.replace(/Child/g, "Child " + membersContainer.attributes["data-child-count"].value)
    break;
  case "parent-template":
    newValue = parseInt(membersContainer.attributes["data-parent-count"].value) + 1;
    membersContainer.attributes["data-parent-count"].value = newValue
    htmlContent = htmlContent.innerHTML.replace(/timestamp/g, newValue)
    htmlContent = htmlContent.replace(/Guardian/g, "Guardian " + membersContainer.attributes["data-parent-count"].value)
    break;
  }
  memberTemplate = document.createElement("div");
  memberTemplate.setAttribute("class", "card");
  memberTemplate.innerHTML = htmlContent
  membersContainer.appendChild(memberTemplate);
  // $(".datepicker" ).datepicker({ dateFormat: 'yy-mm-dd' });
};

