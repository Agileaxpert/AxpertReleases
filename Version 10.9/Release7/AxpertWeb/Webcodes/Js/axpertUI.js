/**
 * Material HomePage
 * @author Prashik
 * @Date   2019-08-04T13:21:51+0530
 */
; (function ($, win) {
    //class axpertUI {
    $_this = this;
    function axpertUI() {
        options = {
            leftSideBar: {
                scrollColor: 'rgba(0,0,0,0.5)',
                scrollWidth: '4px',
                //scrollAlwaysVisible: false,
                scrollAlwaysVisible: true,
                // scrollBorderRadius: '0',
                scrollBorderRadius: '10',
                // scrollRailBorderRadius: '0',
                scrollRailBorderRadius: '10',
                scrollActiveItemWhenPageLoad: true,
                breakpointWidth: 1170,
                enableExpandCollapse: true,
                menuConfiguration: {
                    menuJson: {},
                    alignment: "vertical",//just for info
                    staging: {
                        div: "",
                        divParent: ""
                    },
                    menuTemplete: {
                        menuUl: {
                            opener: `<ul class="ml-menu">`,
                            closer: `</ul>`
                        }, menuLi: {
                            opener: `<li>`,
                            closer: `</li>`,
                            anchorGenerator: function (childObj) {
                                if (typeof OldAppUrl != "undefined" && OldAppUrl == "true") {
                                    if (typeof childObj.oldappurl != 'undefined' && childObj.oldappurl != "")
                                        return `<a href="javascript:void(0);" title="${childObj.name}" class="menu-toggle">
                                <i class="material-icons">folder</i>
                                <span>${childObj.name}</span>
                                </a>`;
                                    else
                                        return "";
                                } else
                                    return `<a href="javascript:void(0);" title="${childObj.name}" class="menu-toggle">
                                <i class="material-icons">folder</i>
                                <span>${childObj.name}</span>
                                </a>`;
                            }
                        }, functionalLi: {
                            opener: `<li class="treeview">`,
                            closer: `</li>`,
                            anchorGenerator: function (childObj) {
                                let iconClass = "";
                                try {
                                    iconClass = AxCustomIcon(childObj)
                                }
                                catch (ex) { }
                                if (iconClass === "") {
                                    if (!childObj.icon) {
                                        if (childObj.target != undefined && childObj.target != "") {
                                            if (childObj.target.indexOf("tstruct.aspx") > -1) {
                                                iconClass = "assignment";
                                            } else if (childObj.target.indexOf("iview.aspx") > -1 || childObj.target.indexOf("iviewInteractive.aspx") > -1) {
                                                iconClass = "view_list";
                                            }
                                            else {
                                                iconClass = "insert_drive_file";
                                            }
                                        }
                                        else {
                                            iconClass = "insert_drive_file";
                                        }
                                    } else {
                                        iconClass = childObj.icon;
                                    }
                                }
                                if (typeof OldAppUrl != "undefined" && OldAppUrl == "true") {
                                    if (typeof childObj.oldappurl != 'undefined' && childObj.oldappurl != "")
                                        return `<a href="javascript:void(0);" title=" ${childObj.name}" onclick="LoadIframe('${childObj.target}')">
                                        <i class="material-icons">${iconClass}</i>
                                        <span>${childObj.name}</span>
                                        </a>`;
                                    else
                                        return "";
                                } else
                                    return `<a href="javascript:void(0);" title=" ${childObj.name}" onclick="LoadIframe('${childObj.target}')">
                                        <i class="material-icons">${iconClass}</i>
                                        <span>${childObj.name}</span>
                                        </a>`;
                            }
                        }
                    },
                    homePage: {
                        url: "",
                        icon: "home"
                    }
                }
            },
            dropdownMenu: {
                effectIn: 'fadeIn',
                effectOut: 'fadeOut'
            },
            loaderDiv: '.page-loader-wrapper',
            navBarDiv: 'nav.navbar',
            search: {
                staging: {
                    div: '#globalSearchinp',
                    divParent: '.search-bar'
                }
            },
            history: {
                staging: {
                    div: "#historyData .setting-list",
                    divParent: ""
                }
            },
            //frameDiv: 'section.content .card',
            frameDiv: '.splitter-wrapper',
            // frameMarginHeight: 0,
            dirLeft: true,
            axpertUserSettings: {},
            rightSideBar: {},
            notificationbar: {},
            navigation: {
                backButton: {
                    div: ".appBackBtn"
                }
            },
            isHybrid: false,
            isMobile: false,
            showMenu: true
        }
        /* Left Sidebar - Function =================================================================================================
        *  You can manage the left sidebar menu options
        *  
        */
        leftSideBar = {
            activate: function (options, isMobile) {
                var _this = this;
                _this.options = options;
                _this.isMobile = isMobile;
                var $body = $('body');
                var $overlay = $('.overlay');
                _this.drawMenu();
                //Close sidebar
                $(window).off("click.leftSideBar").on("click.leftSideBar", function (e) {
                    var $target = $(e.target);
                    if (e.target.nodeName.toLowerCase() === 'i') { $target = $(e.target).parent(); }

                    //if (!$target.hasClass('bars') && _this.isOpen() && $target.parents('#leftsidebar').length === 0 && !$.axpertUI.options.leftSideBar.enableExpandCollapse)
                    if (!$target.hasClass('bars') && _this.isOpen() && $target.parents('#leftsidebar').length === 0) {
                        if (!$target.hasClass('js-right-sidebar')) $overlay.fadeOut();
                        //if (!$body.hasClass('enableExpandCollapse')) {
                        $body.removeClass('overlay-open');
                        //}
                    }
                });

                $.each($('.menu-toggle.toggled'), function (i, val) {
                    $(val).next().slideToggle(0);
                });

                //When page load
                $.each($('.menu .list li.active'), function (i, val) {
                    var $activeAnchors = $(val).find('a:eq(0)');

                    $activeAnchors.addClass('toggled');
                    $activeAnchors.next().show();
                });

                //Collapse or Expand Menu
                $('.menu-toggle').off("click.leftSideBar").on('click.leftSideBar', function (e) {
                    var $this = $(this);
                    var $content = $this.next();

                    if ($($this.parents('ul')[0]).hasClass('list')) {
                        var $not = $(e.target).hasClass('menu-toggle') ? e.target : $(e.target).parents('.menu-toggle');

                        $.each($('.menu-toggle.toggled').not($not).next(), function (i, val) {
                            if ($(val).is(':visible')) {
                                $(val).prev().toggleClass('toggled');
                                $(val).slideUp();
                            }
                        });
                    }

                    $this.toggleClass('toggled');
                    $content.slideToggle(320);
                });

                //Set menu height
                _this.setMenuHeight(true);
                _this.checkStatusForResize(true);
                if (!_this.isMobile) {
                    $(window).off("resize.leftSideBar").on("resize.leftSideBar", function () {
                        _this.setMenuHeight(false);
                        _this.checkStatusForResize(false);
                    });
                }

                //Set Waves
                Waves.attach('.menu .list a', ['waves-block']);
                Waves.init();
            },
            setMenuHeight: function (isFirstTime) {
                var _this = this;
                // try {
                //     $(_this.options.menuConfiguration.staging.divParent).css({ "height": `calc(100vh - ${$(_this.options.menuConfiguration.staging.divParent).offset().top}px)` });
                //     // debugger;
                // } catch (ex) { }

                if (typeof $.fn.slimScroll != 'undefined') {
                    var configs = $.axpertUI.options.leftSideBar;
                    var height = ($(window).height() - ($('.legal').outerHeight() + $('.navbar').innerHeight()));
                    var $el = $('.list');

                    if (!isFirstTime) {
                        $el.slimscroll({
                            destroy: true
                        });
                    }

                    $el.slimscroll({
                        height: height + "px",
                        color: configs.scrollColor,
                        size: configs.scrollWidth,
                        alwaysVisible: configs.scrollAlwaysVisible,
                        borderRadius: configs.scrollBorderRadius,
                        railBorderRadius: configs.scrollRailBorderRadius,
                        touchScrollStep: 75
                    });

                    //Scroll active menu item when page load, if option set = true
                    if ($.axpertUI.options.leftSideBar.scrollActiveItemWhenPageLoad) {
                        var item = $('.menu .list li.active')[0];
                        if (item) {
                            var activeItemOffsetTop = item.offsetTop;
                            if (activeItemOffsetTop > 150) $el.slimscroll({ scrollTo: activeItemOffsetTop + 'px' });
                        }
                    }
                }
            },
            checkStatusForResize: function (firstTime) {
                var _this = this;
                var $body = $('body');
                var $overlay = $('.overlay');
                var $openCloseBar = $('.navbar .navbar-header .bars');
                var width = $body.width();

                if (firstTime) {
                    $body.find('.content, .sidebar').addClass('no-animate').delay(1000).queue(function () {
                        $(this).removeClass('no-animate').dequeue();
                    });
                }

                if (width < $.axpertUI.options.leftSideBar.breakpointWidth) {
                    $body.removeClass('enableExpandCollapse').removeClass('overlay-open');

                    $body.addClass('ls-closed');
                    $openCloseBar.fadeIn();
                }
                else if ($.axpertUI.options.leftSideBar.enableExpandCollapse) {
                    $body.addClass('enableExpandCollapse');

                    $overlay.fadeOut();

                    $body.addClass('ls-closed overlay-open');

                    if (!$.axpertUI.options.showMenu) {
                        $body.removeClass('overlay-open');
                    }

                    // $body.removeClass('ls-closed');
                    // $openCloseBar.fadeIn();
                } else {
                    $body.removeClass('enableExpandCollapse').removeClass('overlay-open');

                    $body.removeClass('ls-closed');
                    $openCloseBar.fadeOut();

                    // $body.addClass('ls-closed');
                    // $openCloseBar.fadeIn();
                }
            },
            isOpen: function () {
                return !$('body').hasClass('enableExpandCollapse') && $('body').hasClass('overlay-open');
            },
            drawMenu: function () {
                //if ($_this.options.menuData.xmlMenuData) {
                //createMenu($_this.options.leftSideBar.menuConfiguration.xmlMenuData);
                //}
                // debugger;
                var _this = this;
                typeof createNewLeftMenu != "undefined" && createNewLeftMenu(_this.options.menuConfiguration);
            }
        };

        // notificationbar
        notificationbar = {
            activate: function (options) {
                var _this = this;
                var $sidebar = $('#notificationbar');
                var $panel = $("#notificationPanel");
                var $overlay = $('.overlay');
                _this.options = options;

                if (typeof _this.options.notificationTimeout != "undefined" && _this.options.notificationTimeout != "" && !isNaN(parseInt(_this.options.notificationTimeout))) {
                    var notifytimeoutms = parseInt(_this.options.notificationTimeout) * 60000;

                    setInterval(CheckNotificiationStringinRedis, notifytimeoutms);

                    $(_this.options.divParent).find(_this.options.staging.options.notification.div).attr("title", _this.options.staging.options.notification.title).text(_this.options.staging.options.notification.title);

                    $("#notifyCountcheck").on('click', function () {
                        $sidebar.toggleClass('open'); 
                    })
                    
                    
                    $(window).click(function (e) {
                        var $target = $(e.target);
                        if (e.target.nodeName.toLowerCase() === 'i') { $target = $(e.target).parent(); }

                        if (!$target.hasClass('js-right-notificationbar') && _this.isOpen() && ($target.parents('#notificationbar').length === 0 || $target.parents('.clickAutoClose').length === 1)) {
                            if ($target.hasClass('close')) {

                            }
                            else if (!$target.hasClass('bars')){ $overlay.fadeOut();
                                $sidebar.removeClass('open');
                            }
                            var notifyCount = $("#notifycount a").length + $("#notifycount p").length;
                            if (notifyCount != 0) {
                                $("#notifyCountcheck").text(notifyCount);
                                $("#notifyCountcheck").show();
                            }
                            if ($('.right-notificationbar').hasClass('open'))
                                $("#notifyCountcheck").hide();
                            // $("#notificationbar").find(".demo-settings").hide();
                            // $("#notificationbar").find(".demo-settings").empty();
                        }
                    });

                    $('.js-right-notificationbar').on('click', function () {
                        $sidebar.toggleClass('open');
                        _this.notifyCount();
                        // $("#notifyCountcheck").empty();
                        //(_this.isOpen())
                        if (_this.isOpen()) { $overlay.fadeIn(); } else { $overlay.fadeOut(); }
                    });
                    $("#Clearnotify").on('click', function () {
                        $sidebar.find(".demo-settings").hide();
                        $sidebar.find(".demo-settings").empty();
                        try {
                            $.ajax({
                                url: 'mainnew.aspx/delALLNotificiationKeyfromRedis',
                                type: 'POST',
                                cache: false,
                                async: true,
                                data: JSON.stringify({
                                    key: true,
                                }),
                                dataType: 'json',
                                contentType: "application/json",
                                success: function (data) {

                                },
                                error: function (error) {

                                }
                            });
                        }
                        catch (exp) {

                        }
                    });

                }
                else {
                    $panel.hide();
                }


            },
            isOpen: function () {
                return $('.right-notificationbar').hasClass('open');
            },
            notifyCount: function () {
                var notifyCount = $("#notifycount a").length + $("#notifycount p").length;
                if (notifyCount != 0) {
                    $("#notifyCountcheck").text(notifyCount);
                    if ($('.right-notificationbar').hasClass('open')) {
                        $("#notifyCountcheck").hide();
                    }

                    else
                        $("#notifyCountcheck").show();
                }
            }


        };

        //==========================================================================================================================
        /* Right Sidebar - Function ================================================================================================
    *  You can manage the right sidebar menu options
    *  
    */
        rightSideBar = {
            activate: function (options) {
                var _this = this;
                var $sidebar = $('#rightsidebar');
                var $overlay = $('.overlay');
                _this.options = options;

                $(_this.options.divParent).find(_this.options.staging.options.history.div).attr("title", _this.options.staging.options.history.title).text(_this.options.staging.options.history.title);
                $(_this.options.divParent).find(_this.options.staging.options.utilities.div).attr("title", _this.options.staging.options.utilities.title).text(_this.options.staging.options.utilities.title);
                $(_this.options.divParent).find(_this.options.staging.options.settings.div).attr("title", _this.options.staging.options.settings.title).text(_this.options.staging.options.settings.title);
                $(_this.options.divParent).find(_this.options.staging.options.settings.options.general.div).text(_this.options.staging.options.settings.options.general.title);
                $(_this.options.divParent).find(_this.options.staging.options.settings.options.settingPanel.div).text(_this.options.staging.options.settings.options.settingPanel.title);
                $(_this.options.divParent).find(_this.options.staging.options.settings.options.split.div).text(_this.options.staging.options.settings.options.split.title);
                $(_this.options.divParent).find(_this.options.staging.options.utilities.options.general.div).text(_this.options.staging.options.utilities.options.general.title);
                $(_this.options.divParent).find(_this.options.staging.options.utilities.options.mobile.div).text(_this.options.staging.options.utilities.options.mobile.title);
                //Close sidebar
                $(window).click(function (e) {
                    var $target = $(e.target);
                    if (e.target.nodeName.toLowerCase() === 'i') { $target = $(e.target).parent(); }

                    if (!$target.hasClass('js-right-sidebar') && _this.isOpen() && ($target.parents('#rightsidebar').length === 0 || $target.parents('.clickAutoClose').length === 1)) {
                        if (!$target.hasClass('bars')) $overlay.fadeOut();
                        $sidebar.removeClass('open');
                    }
                });


                $('.js-right-sidebar').on('click', function () {
                    $sidebar.toggleClass('open');
                    if (_this.isOpen()) { $overlay.fadeIn(); } else { $overlay.fadeOut(); }
                });

                $sidebar.find(".tab-content").each(function (index, elem) {
                    $(elem).find("p").each(function (index, elm) {
                        let liLength = $(elm).next("ul").find("li").filter("[style='display: none;']").length + $(elm).next("ul").find("li").filter("[style='display:none']").length;
                        if (liLength == $(elm).next("ul").find("li").length)
                            $(elm).attr("style", "display:none");
                        else
                            $(elm).attr("style", "display:block");
                    })
                })
            },
            isOpen: function () {
                return $('.right-sidebar').hasClass('open');
        }
        }
        //==========================================================================================================================

        /* Searchbar - Function ================================================================================================
        *  You can manage the search bar
        *  
        */

        search = {
            activate: function (options) {
                var _this = this;
                _this.options = options;
                $(_this.options.staging.searchIconDiv).prop('title', _this.options.staging.title);

                // $('.js-search').find("i").prop('title',_this.options.staging.title);
                //Search button click event
                $('.js-search').on('click', function () {
                    _this.showSearchBar();
                });

                //Close search click event
                $(_this.options.staging.divParent).find('.close-search').on('click', function () {
                    _this.hideSearchBar();
                });

                $(_this.options.staging.divParent).on('click', function (e) {
                    if ($(e.target).parents(".search-bar-wrapper").length == 0) {
                        _this.hideSearchBar();
                    }
                });

                //ESC key on pressed
                $(_this.options.staging.divParent).find('input[type="text"]').on('keyup', function (e) {
                    if (e.keyCode == 27) {
                        _this.hideSearchBar();
                    }
                });
                $(_this.options.staging.divParent).find("i:first").attr("title", _this.options.staging.title);
                $(_this.options.staging.divParent).find(_this.options.staging.options.startsWith.div).attr("title", _this.options.staging.options.startsWith.title).text(_this.options.staging.options.startsWith.title);
                $(_this.options.staging.divParent).find(_this.options.staging.options.contains.div).attr("title", _this.options.staging.options.contains.title).text(_this.options.staging.options.contains.title);
                $(_this.options.staging.divParent).find(_this.options.staging.div).attr("placeholder", this.options.staging.placeholder);

                createAutoComplete(_this.options.staging.div);
            },
            showSearchBar: function () {
                var _this = this;
                $(_this.options.staging.divParent).addClass('open').css({ "height": $(_this.options.staging.divParent).find('input[type="text"]').outerHeight(true) });
                $(_this.options.staging.divParent).find('input[type="text"]').focus();
            },
            hideSearchBar: function () {
                var _this = this;
                $(_this.options.staging.divParent).removeClass('open');
                $(_this.options.staging.divParent).find('input[type="text"]').val('');
            },
            searchModeContains: function (contains = true) {
                var _this = this;
                if (contains) {
                    GlobalSrchCondition = 'Contains';
                } else {
                    GlobalSrchCondition = 'StartsWith';
                }
                var searchElem = $(_this.options.staging.div)
                searchElem.val() && searchElem.val().length > 1 && searchElem.focus().autocomplete("search", searchElem.val());
            }
        }
        //==========================================================================================================================

        /* Navbar - Function =======================================================================================================
        *  You can manage the navbar
        *  
        */
        navbar = {
            activate: function () {
                var $body = $('body');
                var $overlay = $('.overlay');
                var $navbarCollapse = $('.navbar-collapse');
                //Open left sidebar panel
                $('.bars').on('click', function () {
                    $body.toggleClass('overlay-open');
                    //if ($body.hasClass('overlay-open') && !$.axpertUI.options.leftSideBar.enableExpandCollapse) 
                    if ($body.hasClass('overlay-open') && !$body.hasClass('enableExpandCollapse')) {
                        $overlay.fadeIn();
                    } else {
                        $overlay.fadeOut();
                    }
                    if ($('.navbar-toggle').is(':visible')) {
                        $navbarCollapse.slideUp(function () {
                            $navbarCollapse.removeClass('in').removeAttr('style');
                        });
                    }

                });

                //Close collapse bar on click event
                $('.nav [data-close="true"]').on('click', function () {
                    if ($('.navbar-toggle').is(':visible')) {
                        $navbarCollapse.slideUp(function () {
                            $navbarCollapse.removeClass('in').removeAttr('style');
                        });
                    }
                });
            }
        }
        //==========================================================================================================================

        /* Input - Function ========================================================================================================
        *  You can manage the inputs(also textareas) with name of class 'form-control'
        *  
        */
        input = {
            activate: function ($parentSelector) {
                $parentSelector = $parentSelector || $('body');

                //On focus event
                $parentSelector.find('.form-control').focus(function () {
                    $(this).closest('.form-line').addClass('focused');
                });

                //On focusout event
                $parentSelector.find('.form-control').focusout(function () {
                    var $this = $(this);
                    if ($this.parents('.form-group').hasClass('form-float')) {
                        if ($this.val() == '') { $this.parents('.form-line').removeClass('focused'); }
                    }
                    else {
                        $this.parents('.form-line').removeClass('focused');
                    }
                });

                //On label click
                $parentSelector.on('click', '.form-float .form-line .form-label', function () {
                    $(this).parent().find('input').focus();
                });

                //Not blank form
                $parentSelector.find('.form-control').each(function () {
                    if ($(this).val() !== '') {
                        $(this).parents('.form-line').addClass('focused');
                    }
                });
            }
        }
        //==========================================================================================================================

        /* Form - Select - Function ================================================================================================
        *  You can manage the 'select' of form elements
        *  
        */
        select = {
            activate: function () {
                if ($.fn.selectpicker) { $('select:not(.ms)').selectpicker(); }
            }
        }
        //==========================================================================================================================

        /* DropdownMenu - Function =================================================================================================
        *  You can manage the dropdown menu
        *  
        */

        dropdownMenu = {
            activate: function () {
                var _this = this;

                $('.dropdown, .dropup, .btn-group').on({
                    "show.bs.dropdown": function () {
                        var dropdown = _this.dropdownEffect(this);
                        _this.dropdownEffectStart(dropdown, dropdown.effectIn);
                    },
                    "shown.bs.dropdown": function () {
                        var dropdown = _this.dropdownEffect(this);
                        if (dropdown.effectIn && dropdown.effectOut) {
                            _this.dropdownEffectEnd(dropdown, function () { });
                        }
                    },
                    "hide.bs.dropdown": function (e) {
                        var dropdown = _this.dropdownEffect(this);
                        if (dropdown.effectOut) {
                            e.preventDefault();
                            _this.dropdownEffectStart(dropdown, dropdown.effectOut);
                            _this.dropdownEffectEnd(dropdown, function () {
                                dropdown.dropdown.removeClass('open');
                            });
                        }
                    }
                });

                //Set Waves
                Waves.attach('.dropdown-menu li a', ['waves-block']);
                Waves.init();
            },
            dropdownEffect: function (target) {
                var effectIn = $.axpertUI.options.dropdownMenu.effectIn, effectOut = $.axpertUI.options.dropdownMenu.effectOut;
                var dropdown = $(target), dropdownMenu = $('.dropdown-menu', target);

                if (dropdown.length > 0) {
                    var udEffectIn = dropdown.data('effect-in');
                    var udEffectOut = dropdown.data('effect-out');
                    if (udEffectIn !== undefined) { effectIn = udEffectIn; }
                    if (udEffectOut !== undefined) { effectOut = udEffectOut; }
                }

                return {
                    target: target,
                    dropdown: dropdown,
                    dropdownMenu: dropdownMenu,
                    effectIn: effectIn,
                    effectOut: effectOut
                };
            },
            dropdownEffectStart: function (data, effectToStart) {
                if (effectToStart) {
                    data.dropdown.addClass('dropdown-animating');
                    data.dropdownMenu.addClass('animated dropdown-animated');
                    data.dropdownMenu.addClass(effectToStart);
                }
            },
            dropdownEffectEnd: function (data, callback) {
                var animationEnd = 'webkitAnimationEnd mozAnimationEnd MSAnimationEnd oanimationend animationend';
                data.dropdown.one(animationEnd, function () {
                    data.dropdown.removeClass('dropdown-animating');
                    data.dropdownMenu.removeClass('animated dropdown-animated');
                    data.dropdownMenu.removeClass(data.effectIn);
                    data.dropdownMenu.removeClass(data.effectOut);

                    if (typeof callback == 'function') {
                        callback();
                    }
                });
            }
        }

        tooltipsPopovers = {
            activate: function () {
                //Tooltip
                $('[data-toggle="tooltip"]').tooltip({
                    container: 'body'
                });

                //Popover
                $('[data-toggle="popover"]').popover();
            }
        }



        //==========================================================================================================================

        /* Browser - Function ======================================================================================================
        *  You can manage browser
        *  
        */

        browser = {
            activate: function (isHybrid) {
                var _this = this;
                _this.isHybrid = isHybrid;

                _this.browsers = {
                    edge: 'Microsoft Edge',
                    edgeLegacy: 'Microsoft Edge Legacy',
                    ie10: 'Internet Explorer 10',
                    ie11: 'Internet Explorer 11',
                    opera: 'Opera',
                    firefox: 'Mozilla Firefox',
                    chrome: 'Google Chrome',
                    safari: 'Safari',
                }

                var className = _this.getClassName();

                if (className !== '') $('html').addClass(className);

                typeof isiOS && isiOS ? $("body").addClass("iOS") : "";

                _this.isHybrid ? $("body").addClass("isHybrid") : "";
            },
            getBrowser: function () {
                var _this = this;
                var userAgent = navigator.userAgent.toLowerCase();

                if (/edge/i.test(userAgent)) {
                    return _this.browsers.edgeLegacy;
                } else if (/edg/i.test(userAgent)) {
                    return _this.browsers.edge;
                } else if (/rv:11/i.test(userAgent)) {
                    return _this.browsers.ie11;
                } else if (/msie 10/i.test(userAgent)) {
                    return _this.browsers.ie10;
                } else if (/opr/i.test(userAgent)) {
                    return _this.browsers.opera;
                } else if (/chrome/i.test(userAgent)) {
                    return _this.browsers.chrome;
                } else if (/firefox/i.test(userAgent)) {
                    return _this.browsers.firefox;
                } else if (!!navigator.userAgent.match(/Version\/[\d\.]+.*Safari/)) {
                    return _this.browsers.safari;
                }

                return undefined;
            },
            getClassName: function () {
                var _this = this;
                var browser = this.getBrowser();

                if (browser === _this.browsers.edge) {
                    return 'edge';
                } else if (browser === _this.browsers.edgeLegacy) {
                    return 'edgeLegacy';
                } else if (browser === _this.browsers.ie11) {
                    return 'ie11';
                } else if (browser === _this.browsers.ie10) {
                    return 'ie10';
                } else if (browser === _this.browsers.opera) {
                    return 'opera';
                } else if (browser === _this.browsers.chrome) {
                    return 'chrome';
                } else if (browser === _this.browsers.firefox) {
                    return 'firefox';
                } else if (browser === _this.browsers.safari) {
                    return 'safari';
                } else {
                    return '';
                }
            }
        }

        setUserOptions = {
            activate: function (options,compressedMode) {
                var _this = this;
                _this.options = options;
                _this.compressedMode=compressedMode;
                _this.initHeader();
                _this.initProfile();
                _this.initSettings();
                _this.initUtilities();
            },
            initHeader: function () {
                var _this = this.options.settings.axUserOptions;
                var _thisStag = this.options.staging;
                if (_this.splitIcon) {
                    $(_thisStag.splitIcon.div).attr("style", "display:" + _this.splitIcon.display);
                    $(_thisStag.splitIcon.div).find("i:first").attr("title", _thisStag.splitIcon.title);
                    $(_thisStag.splitIcon.div).find(_thisStag.splitIcon.options.horizontalSplit.div).attr("title", _thisStag.splitIcon.options.horizontalSplit.title).find("span").attr("title", _thisStag.splitIcon.options.horizontalSplit.title).text(_thisStag.splitIcon.options.horizontalSplit.title);
                    $(_thisStag.splitIcon.div).find(_thisStag.splitIcon.options.verticalSplit.div).attr("title", _thisStag.splitIcon.options.verticalSplit.title).find("span").attr("title", _thisStag.splitIcon.options.verticalSplit.title).text(_thisStag.splitIcon.options.verticalSplit.title)
                    $(_thisStag.splitIcon.div).find(_thisStag.splitIcon.options.clearSplit.div).attr("title", _thisStag.splitIcon.options.clearSplit.title).find("span").attr("title", _thisStag.splitIcon.options.clearSplit.title).text(_thisStag.splitIcon.options.clearSplit.title);
                }
                if (_this.compressedMode) {
                    $(_thisStag.uiSelector.div).attr("style", "display:" + _this.compressedMode.display);
                    $(_thisStag.uiSelector.div).find("i:first").attr("title", _thisStag.uiSelector.title);
                }

                $(_thisStag.optionsPanel.div).find("i:first").attr("title", _thisStag.optionsPanel.title);
                if (_this.LicInfo) {
                    $(_thisStag.LicInfo.div).attr("style", "display:" + _this.LicInfo.display);
                    $(_thisStag.LicInfo.div).find(_thisStag.LicInfo.divClick).attr("onclick", _this.LicInfo.onclick);
                    $(_thisStag.LicInfo.div).find(_thisStag.LicInfo.divTitle).attr("title", _this.LicInfo.title);
                }
            },
            initProfile: function () {
                var _this = this.options.settings.axUserOptions;
                var _thisStag = this.options.staging;
                if (_this.axAppName) {
                    $(_thisStag.axAppName.div).attr("onclick", _this.axAppName.onclick);
                    $(_thisStag.axAppName.div).text(_this.axAppName.appName);
                    $(_thisStag.axAppName.div).attr("title", _this.axAppName.appName);
                }
                if (_this.AxNickName) {
                    $(_thisStag.AxNickName.div).append("<span>" + _this.AxNickName.NickName + "</span>");
                    $(_thisStag.userProfile.div).find(_thisStag.userProfile.options.userName.icon).text(_this.AxNickName.NickName.trim().charAt(0).toUpperCase());
                }

                if (_this.AxAppLogo)
                    $(_thisStag.AxAppLogo.div).find(_thisStag.AxAppLogo.AppLogo).attr("src", _this.AxAppLogo.imgSrc);

                if (_this.AxUserEmail) {
                    $(_thisStag.AxUserEmail.div).attr("style", "display:" + _this.AxUserEmail.display);
                    $(_thisStag.AxUserEmail.div).append("<span>" + _this.AxUserEmail.email + "</span>");
                }
                if (_this.GlobalParams) {
                    $(_thisStag.GlobalParams.div).attr("style", "display:" + _this.GlobalParams.display);
                    $(_thisStag.GlobalParams.div).next("li.divider").attr("style", "display:" + _this.GlobalParams.display);
                    // $(_thisStag.GlobalParams.div).find(_thisStag.GlobalParams.divTitle).attr("title", _this.GlobalParams.title);
                    // $(_thisStag.GlobalParams.div).find(_thisStag.GlobalParams.divTitle).attr("data-content", $(_thisStag.GlobalParams.divData).html());
                    // $(_thisStag.GlobalParams.div).find("a").attr("title", _thisStag.GlobalParams.title).find("span").text(_thisStag.GlobalParams.title);
                    $(_thisStag.GlobalParams.div).find(_thisStag.GlobalParams.divTitle + " span").html($(_thisStag.GlobalParams.divData).html());
                }
                if (_this.GlobalParamsonclick)
                    $(_thisStag.GlobalParams.div).find(_thisStag.GlobalParams.divClick).attr("onclick", _this.GlobalParamsonclick.onclick);
                if(_this.Refresh){
                    $(_thisStag.refreshMenu.div).attr("onclick", _this.Refresh.onclick);
                    $(_thisStag.refreshMenu.div).find("a").attr("title", _thisStag.refreshMenu.title).find("span").text(_thisStag.refreshMenu.title);
                }
                if (_this.Logout)
                    $(_thisStag.Logout.div).attr("onclick", _this.Logout.onclick);
                $(_thisStag.Logout.div).attr("title", _thisStag.Logout.title).find("span").text(_thisStag.Logout.title);
            },
            initSettings: function () {
                var _this = this.options.settings.axUserOptions;
                var _thisStag = this.options.staging;
                if (_this.About) {
                    $(_thisStag.About.div).attr("onclick", _this.About.onclick);
                    $(_thisStag.About.div).attr("title", _thisStag.About.title).find("span").text(_thisStag.About.title);
                }
                if (_this.InMemoryDB) {
                    $(_thisStag.InMemoryDB.div).attr("style", "display:" + _this.InMemoryDB.display);
                    $(_thisStag.InMemoryDB.div).attr("onclick", _this.InMemoryDB.onclick);
                    $(_thisStag.InMemoryDB.div).attr("title", _thisStag.InMemoryDB.title).find("span").text(_thisStag.InMemoryDB.title);
                }
                if (_this.auditReport) {
                    $(_thisStag.auditReport.div).attr("style", "display:" + _this.auditReport.display);
                    $(_thisStag.auditReport.div).find(_thisStag.auditReport.divClick).attr("onclick", _this.auditReport.onclick);
                    $(_thisStag.auditReport.div).attr("title", _thisStag.auditReport.title).find("span").text(_thisStag.auditReport.title);
                }
                if (_this.showLog) {
                    $(_thisStag.showLog.div).attr("style", "display:" + _this.showLog.display);
                    $(_thisStag.showLog.div).find(_thisStag.showLog.divClick).attr("onclick", _this.showLog.onclick);
                    $(_thisStag.showLog.div).attr("title", _thisStag.showLog.title).find("span:first").text(_thisStag.showLog.title);
                }

                if (_this.executionLog) {
                    $(_thisStag.executionLog.div).attr("style", "display:" + _this.executionLog.display);
                    $(_thisStag.executionLog.div).find(_thisStag.executionLog.divClick).attr("onclick", _this.executionLog.onclick);
                    $(_thisStag.executionLog.div).attr("title", _thisStag.executionLog.title).find("span:first").text(_thisStag.executionLog.title);
                }               

                if(_this.uiSelector){
                    $(_thisStag.uiSelector.div).attr("style", "display:" + _this.uiSelector.display);
                    $(_thisStag.uiSelector.div).find(_thisStag.uiSelector.divClick).attr("onclick", _this.uiSelector.onclick);
                    $(_thisStag.uiSelector.div).attr("title", _thisStag.uiSelector.title).find("span:first").text(_thisStag.uiSelector.title);
                }
                if (_this.traceValue) {
                    if (_this.traceValue.traceVal == "True") {
                        $(_thisStag.traceValue.div).find(_thisStag.traceValue.divControl).attr("checked", "checked");
                        $(_thisStag.traceValue.div).find(_thisStag.traceValue.divspan).attr("title", _thisStag.traceValue.title.on);
                    }
                    else {
                        $(_thisStag.traceValue.div).find(_thisStag.traceValue.divControl).removeAttr("checked");
                        $(_thisStag.traceValue.div).find(_thisStag.traceValue.divspan).attr("title", _thisStag.traceValue.title.off);
                    }
                    $(_thisStag.traceValue.div).find(_thisStag.traceValue.divClick).attr("onclick", _this.traceValue.onclick);
                }
               
                if (_this.modernUiValue) {
                    // $(_thisStag.traceModernUiValue.div).find('label').attr("onclick", _this.traceModernUiValue.onclick);
                    // $(_thisStag.traceModernUiValue.div).find(_thisStag.traceModernUiValue.divspan).text(_thisStag.traceModernUiValue.caption);
                    if (!this.compressedMode) {
                        $(_thisStag.modernUiValue.div).find('input').prop("checked", true);
                        $(_thisStag.modernUiValue.div).find(_thisStag.modernUiValue.divSpan).attr("title", _thisStag.modernUiValue.title.on);
                    }
                    else {
                        $(_thisStag.modernUiValue.div).find('input').prop("checked", false);
                        $(_thisStag.modernUiValue.div).find(_thisStag.modernUiValue.divSpan).attr("title", _thisStag.modernUiValue.title.off);
                    }
                    $(".setting-panel").css({ "height": "calc(100vh - " + Math.round($(".tab-content").offset().top) + "px", "overflow": "auto" });
                   $($(_thisStag.modernUiValue.div).find('input')).click(function(e){
                       if($(_thisStag.modernUiValue.div).find('input').is(":checked"))
                       {
                        $(_thisStag.modernUiValue.div).find(_thisStag.modernUiValue.divSpan).attr("title", _thisStag.modernUiValue.title.on);
                        window[_this.modernUiValue.onclick](false);
                        // if(!$('body').hasClass('compressedModeUI'))
                        // $(".setting-panel").css({ "height": "calc(100vh - " + Math.round($(".tab-content").offset().top) + "px", "overflow": "auto" });
                       }
                       else{
                        $(_thisStag.modernUiValue.div).find(_thisStag.modernUiValue.divSpan).attr("title", _thisStag.modernUiValue.title.off);
                        window[_this.modernUiValue.onclick](true);
                        // if(!$('body').hasClass('compressedModeUI'))
                        // $(".setting-panel").css({ "height": "calc(100vh - " + Math.round($(".tab-content").offset().top) + "px", "overflow": "auto" });
                       }
                    //    if(e.target.type == "checkbox")
                    setTimeout(function(){
                        $(".setting-panel").css({ "height": "calc(100vh - " + Math.round($(".tab-content").offset().top) + "px", "overflow": "auto" });
                    }, 500);
                   })
                }
                if (_this.globalsettings) {
                    $(_thisStag.globalsettings.div).attr("style", "display:" + _this.globalsettings.display);
                    $(_thisStag.globalsettings.div).attr("onclick", _this.globalsettings.onclick);
                    $(_thisStag.globalsettings.div).attr("title", _thisStag.globalsettings.title).find("span").text(_thisStag.globalsettings.title);
                }
                if (_this.AppConfig) {
                    $(_thisStag.AppConfig.div).attr("style", "display:" + _this.AppConfig.display);
                    $(_thisStag.AppConfig.div).attr("onclick", _this.AppConfig.onclick);
                    $(_thisStag.AppConfig.div).attr("title", _thisStag.AppConfig.title).find("span").text(_thisStag.AppConfig.title);
                }
                if (_this.ChangePassword) {
                    $(_thisStag.ChangePassword.div).attr("style", "display:" + _this.ChangePassword.display);
                    $(_thisStag.ChangePassword.div).attr("onclick", _this.ChangePassword.onclick);
                    $(_thisStag.ChangePassword.div).attr("title", _thisStag.ChangePassword.title).find("span").text(_thisStag.ChangePassword.title);
                }
                if (_this.userManual) {
                    $(_thisStag.userManual.div).attr("style", "display:" + _this.userManual.display);
                    $(_thisStag.userManual.div).attr("onclick", _this.userManual.onclick);
                    $(_thisStag.userManual.div).attr("title", _thisStag.userManual.title).find("span").text(_thisStag.userManual.title);
                }

                $(".setting-panel").css({ "height": "calc(100vh - " + Math.round($(".tab-content").offset().top) + "px", "overflow": "auto" });
            },
            initUtilities: function () {
                var _this = this.options.settings.axUserOptions;
                var _thisStag = this.options.staging;
                if (_this.qrCodeBtnWrapper) {
                    $(_thisStag.qrCodeBtnWrapper.div).attr("style", "display:" + _this.qrCodeBtnWrapper.display).parents("ul").prev("p").attr("style", "display:" + _this.qrCodeBtnWrapper.display);
                    $(_thisStag.qrCodeBtnWrapper.div).find(_thisStag.qrCodeBtnWrapper.divClick).attr("onclick", _this.qrCodeBtnWrapper.onclick);
                    $(_thisStag.qrCodeBtnWrapper.div).attr("title", _thisStag.qrCodeBtnWrapper.title).find("span").text(_thisStag.qrCodeBtnWrapper.title);
                }
                if (_this.WidgetBuilder) {
                    $(_thisStag.WidgetBuilder.div).attr("style", "display:" + _this.WidgetBuilder.display);
                    $(_thisStag.WidgetBuilder.div).attr("onclick", _this.WidgetBuilder.onclick);
                    $(_thisStag.WidgetBuilder.div).attr("title", _thisStag.WidgetBuilder.title).find("span").text(_thisStag.WidgetBuilder.title);
                }
                if (_this.pageBuilderBtn) {
                    $(_thisStag.pageBuilderBtn.div).attr("style", "display:" + _this.pageBuilderBtn.display);
                    $(_thisStag.pageBuilderBtn.div).attr("onclick", _this.pageBuilderBtn.onclick);
                    $(_thisStag.pageBuilderBtn.div).attr("title", _thisStag.pageBuilderBtn.title).find("span").text(_thisStag.pageBuilderBtn.title);
                }
                if (_this.Dashboard) {
                    $(_thisStag.Dashboard.div).attr("style", "display:" + _this.Dashboard.display);
                    $(_thisStag.Dashboard.div).attr("onclick", _this.Dashboard.onclick);
                    $(_thisStag.Dashboard.div).attr("title", _thisStag.Dashboard.title).find("span").text(_thisStag.Dashboard.title);
                }
                if (_this.Responsibilities) {
                    $(_thisStag.Responsibilities.div).attr("style", "display:" + _this.Responsibilities.display);
                    $(_thisStag.Responsibilities.div).attr("onclick", _this.Responsibilities.onclick);
                    $(_thisStag.Responsibilities.div).attr("title", _thisStag.Responsibilities.title).find("span").text(_thisStag.Responsibilities.title);
                }
                if (_this.ExportData) {
                    $(_thisStag.ExportData.div).attr("style", "display:" + _this.ExportData.display);
                    $(_thisStag.ExportData.div).attr("onclick", _this.ExportData.onclick);
                    $(_thisStag.ExportData.div).attr("title", _thisStag.ExportData.title).find("span").text(_thisStag.ExportData.title);
                }
                if (_this.ImportData) {
                    $(_thisStag.ImportData.div).attr("style", "display:" + _this.ImportData.display);
                    $(_thisStag.ImportData.div).attr("onclick", _this.ImportData.onclick);
                    $(_thisStag.ImportData.div).attr("title", _thisStag.ImportData.title).find("span").text(_thisStag.ImportData.title);
                }
                if (_this.ImportHistory) {
                    $(_thisStag.ImportHistory.div).attr("style", "display:" + _this.ImportHistory.display);
                    $(_thisStag.ImportHistory.div).attr("onclick", _this.ImportHistory.onclick);
                    $(_thisStag.ImportHistory.div).attr("title", _thisStag.ImportHistory.title).find("span").text(_thisStag.ImportHistory.title);
                }
                if (_this.WorkFlow) {
                    $(_thisStag.WorkFlow.div).attr("style", "display:" + _this.WorkFlow.display);
                    $(_thisStag.WorkFlow.div).attr("onclick", _this.WorkFlow.onclick);
                    $(_thisStag.WorkFlow.div).attr("title", _thisStag.WorkFlow.title).find("span").text(_thisStag.WorkFlow.title);
                }
            }
        }

        init = function (initOptions) {
            this.options = $.extend(true, {}, this.options, initOptions);
            //initOptions = this.options;
            // this.options.frameMarginHeight = $(this.options.frameDiv).parents("section").offset().top + parseInt($(this.options.frameDiv).css("margin-bottom"), 10);
            // debugger;
            // $(this.options.frameDiv).css({ "height": "calc(100vh - " + this.options.frameMarginHeight + "px" });

            if (!this.options.dirLeft) {
                // debugger;
                $(".navbar-right").removeClass("navbar-right").addClass("navbar-left");
                $(".pull-right:not(.dropdown-menu)").removeClass("pull-right").addClass("pull-left");
                $("[data-placement=right").attr("data-placement", "left");
            }


            browser.activate(this.options.isHybrid);
            setUserOptions.activate(this.options.axpertUserSettings,this.options.compressedMode);
            leftSideBar.activate(this.options.leftSideBar, this.options.isMobile);
            rightSideBar.activate(this.options.rightSideBar);
            notificationbar.activate(this.options.notificationbar);
            navbar.activate();
            dropdownMenu.activate();
            input.activate();
            select.activate();
            search.activate(this.options.search);
            tooltipsPopovers.activate();
            $(this.options.navigation.backButton.div).hide();
            setTimeout(function () { $(this.options.loaderDiv).fadeOut(); }, 50);

            return this.options;
        }
        //==========================================================================================================================
        return { options, leftSideBar, rightSideBar, notificationbar, search, navbar, input, select, dropdownMenu, browser, init }
    }
    $.axpertUI = new axpertUI();
    // debugger;
})(jQuery, window);



$(function () {
    if (window.location.href.indexOf(".html") > -1) {
        $.axpertUI.init({
            leftSideBar: {
                menuConfiguration: {
                    menuJson: menuJsonData,
                    staging: {
                        div: "#leftsidebar .menu ul.list"
                    },
                    menuTemplete: {
                        /*menuUl: {
                            opener: `<ul class="treeview-menu">`,
                            closer: `</ul>`
                        }, menuLi: {
                            opener: `<li class="treeview">`,
                            closer: `</li>`,
                            anchorGenerator: function (childObj) {
                                return `<a href="javascript:void(0)" title="${childObj.name}">
                                        <i class="icon-left-menu fa fa-folder" style="width:22px"></i>
                                        <span>${childObj.name}</span>
                                        <span class="pull-right-container">
                                        <i class="fa fa-angle-down pull-right"></i>
                                        </span>
                                        </a>`;
                            }
                        }, functionalLi: {
                            opener: `<li class="treeview">`,
                            closer: `</li>`,
                            anchorGenerator: function (childObj) { 
                                let iconClass = "";
                                try {
                                    iconClass = AxCustomIcon(childObj)
                                }
                                catch (ex) { }
                                if (iconClass === "") {
                                    if (childObj.target != undefined && childObj.target != "") {
                                        if (childObj.target.indexOf("tstruct.aspx") > -1) {
                                            iconClass = "fa fa-wpforms";
                                        } else if (childObj.target.indexOf("iview.aspx") > -1 || childObj.target.indexOf("iviewInteractive.aspx") > -1) {
                                            iconClass = "fa fa-table";
                                        }
                                        else {
                                            iconClass = "fa fa-file-text";
                                        }
                                    }
                                    else {
                                        iconClass = "fa fa-file-text";
                                    }
                                }
                                return `<a class="menuList"  href="${childObj.target}" title=" ${childObj.name}" onclick="LoadIframe('${childObj.target}')">
                                        <i class="icon-left-menu ${iconClass}" style="width:22px"></i>
                                        <span>${childObj.name}</span>
                                        </a>`;
                            }
                        }*/
                    }
                }
            }
        });
    }
});
