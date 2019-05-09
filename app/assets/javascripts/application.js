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

$(document).ready(function () {
  $(".datepicker").datepicker({
    changeMonth: true,
    changeYear: true,
    yearRange: "1920:2019",
    dateFormat: 'yy-mm-dd'
  });
  cloneTemplate('child-template', 'children')

  $('.datepicker').on("change", function () {
    console.log($(this).val())
    console.log(Date.parse($(this).val()))
  });
});

$(document).on('click', '.close', function (e) {
  e.preventDefault();
  object = $(this).data("type")
  $(this).closest('.additional-item').fadeOut(500, function () {
    $(this).remove();
    resetItemHeaders(object)
  });

})

$(document).on('click', '.add-parent', function (e) {
  e.preventDefault();
  cloneTemplate('parent-template', 'parents')
})

$(document).on('click', '.add-child', function (e) {
  e.preventDefault();
  cloneTemplate('child-template', 'children')
})


window.addEventListener('load', function () {
  // Fetch all the forms we want to apply custom Bootstrap validation styles to
  var forms = document.getElementsByClassName('needs-validation');
  // Loop over them and prevent submission
  Array.prototype.filter.call(forms, function (form) {
    form.addEventListener('submit', function (event) {
      if (form.checkValidity() === false) {
        event.preventDefault();
        event.stopPropagation();
      }
      form.classList.add('was-validated');
    }, false);
  });
}, false);

function resetItemHeaders(type) {
  if (type == "parent") {
    title = "Parent/Guardian "
    target = '.parents .item-title'
  } else {
    title = "Child "
    target = '.children .item-title'
  }

  $(target).each(function (index) {
    index = index + 1
    $(this).html(title + index)
  })
}

function cloneTemplate(templateName, section) {
  var templateSection = document.getElementsByClassName(section)[0];
  var membersContainer = document.getElementsByClassName('members')[0];
  htmlContent = document.getElementById(templateName)
  switch (templateName) {
    case "child-template":
      childIndex = parseInt($('.children').children().length) + 1;
      membersContainer.attributes["data-child-count"].value = childIndex
      htmlContent = htmlContent.innerHTML.replace(/timestamp/g, childIndex)
      htmlContent = htmlContent.replace(/Child/g, "Child " + childIndex)
      break;
    case "parent-template":
      parentIndex = parseInt($('.parents').children().length) + 1;
      membersContainer.attributes["data-parent-count"].value = parentIndex
      htmlContent = htmlContent.innerHTML.replace(/timestamp/g, parentIndex)
      htmlContent = htmlContent.replace(/Parent\/Guardian/g, "Parent/Guardian " + parentIndex)
      break;
  }
  memberTemplate = document.createElement("div");
  memberTemplate.setAttribute("class", "additional-item");
  memberTemplate.innerHTML = htmlContent
  templateSection.appendChild(memberTemplate);

  $('.datepicker').on("change", function () {
    console.log($(this).val())
    console.log(Date.parse($(this).val()))
  });
};
