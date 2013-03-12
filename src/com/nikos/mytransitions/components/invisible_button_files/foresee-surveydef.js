FSR.surveydefs = [{
    site: 'adobe.com',
    name: 'browse',
    section: 'sitewide',
    invite: {
        when: 'onentry'
    },
    pop: {
        when: 'later'
    },
    links: {
        pause: [{
            tag: 'a',
            attribute: 'href',
            patterns: ['/go/', '/buy/', 'cfusion/store', 'products']
        }]
    },
    criteria: {
        sp: 1,
        lf: 1,
        
        locales: [{
            locale: 'de',
            sp: 0,
            lf: 1
        }, {
            locale: 'ja',
            sp: 1,
            lf: 1
        }]
    },
    include: {
        urls: ['.']
    }
}];

FSR.properties = {
    repeatdays: 90,
    
    language: {
        locale: 'en_us',
        
        src: 'variable',
        type: 'client',
        name: 'locale',
        locales: [{
            match: 'de',
            locale: 'de'
        }, {
            match: 'ja',
            locale: 'ja'
        }]
    },
    
    exclude: {
        cookies: [{
            name: 'ForeseeSurveyShown',
            value: 'true'
        }]
    },
    
    invite: {
        content: '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"><HTML><HEAD><TITLE>Foresee Invite</TITLE></HEAD><BODY><div id=\"fsrinvite\"><div id=\"fsrcontainer\"><div class=\"fsri_sitelogo\"><img src=\"{%baseHref%}adobe.jpg\" alt=\"Site Logo\"></div><div class=\"fsri_fsrlogo\"><img src=\"{%baseHref%}fsrlogo.gif\" alt=\"Site Logo\"></div></div><div class=\"fsri_body\"><br><br><br><b><font size=\"3\">We\'d like your feedback.</b></font><br><br>Thank you for visiting Adobe.com. You have been randomly selected to participate in a visitor satisfaction survey that should take no more than 5 minutes to complete. Your feedback will be used to improve visitor experience on the Adobe website.<br><br><b>The survey is designed to measure your entire site experience and will appear at the <u>end of your visit</u>.</b><br><br><font size=\"1\">This survey is conducted by an independent company, ForeSee Results.</font><br></div></div></BODY></HTML>',
        
        locales: [{
            locale: 'de',
            content: '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"><HTML><HEAD><TITLE>Foresee Invite</TITLE></HEAD><BODY><div id=\"fsrinvite\"><div id=\"fsrcontainer\"><div class=\"fsri_sitelogo\"><img src=\"{%baseHref%}adobe.jpg\" alt=\"Site Logo\"></div><div class=\"fsri_fsrlogo\"><img src=\"{%baseHref%}fsrlogo.gif\" alt=\"Site Logo\"></div></div><div class=\"fsri_body\"><br><br><br>Vielen Dank für Ihren Besuch bei Adobe.com!  Wir brauchen Ihr Feedback. Sie wurden ausgewählt an einer Website-Besucherumfrage teilzunehmen, die ungefähr 5 Minuten Ihrer Zeit in Anspruch nehmen wird. Ihre Antworten werden dazu beitragen, das Anwendererlebnis auf der Adobe-Website zu verbessern.<br><br></div></div></BODY></HTML>',
            buttons: {
                accept: "Weiter",
                decline: 'Nein danke'
            }
        }, {
            locale: 'ja',
            content: '<!DOCTYPE HTML PUBLIC \"-//W3C//DTD HTML 4.0 Transitional//EN\"><HTML><HEAD><TITLE>Foresee Invite</TITLE></HEAD><BODY><div id=\"fsrinvite\"><div id=\"fsrcontainer\"><div class=\"fsri_sitelogo\"><img src=\"{%baseHref%}adobe.jpg\" alt=\"Site Logo\"></div><div class=\"fsri_fsrlogo\"><img src=\"{%baseHref%}fsrlogo.gif\" alt=\"Site Logo\"></div></div><div class=\"fsri_body\"><br><br><br><b><font size=\"3\">アドビのウェブサイトをご利用いただきありがとうございます。</b></font><br><br>お忙しいところ誠に恐れ入りますが、私どものウエブサイトご利用の最後に、ウエブサイト改善のための 5 分程度の調査にご協力をお願いしてもよろしいですか。この調査はアドビシステムズの委託により、米国 ForeSee Results 社が実施します。</b><br><br></div></div></BODY></HTML>',
            buttons: {
                accept: "協力する",
                decline: '辞退する'
            }
        }],
        
        exclude: {
            local: ['/cfusion/', '/newsletters/edge/', '/help/', '/ion/', '/brilliant/', 'labs.adobe.com', 'createpdf.adobe.com', 'partners.adobe.com/toolkit', 'adobemall.co.kr/AdobeMall/', '/software/flash/about/', 'photographersdirectory.adobe.com', 'partners.adobe.com/resellerfinder/na/findreseller.jsp', 'cooljobs.adobe.com/frameset.html', 'demo.adobe.com', 'sjw2.adobe.com/AdobeUserGroup/events.asp', 'sjw2.adobe.com/AdobeUserGroup/review.asp', 'onlineservices.adobe.com/account/tsu/a1', 'readstep2_servefile.html', 'readstep2_thankyou.html', 'readstep3_thankyou.html', 'macromedia.com/support/', '/jp/devnet/', '/de/devnet/', '/de/software/flash/about/', '/jp/software/flash/about/', 'service.stage.acrobat.com', 'service.acrobat.com', '/events/main.jsp', 'cps-internal.corp.adobe.com', 'omniture.com', /^http:\/\/get(2?)\./],
            referrer: ['adobe.com/downloads', /^http:\/\/get(2?)\./]
        },
        include: {
            local: ['.']
        },
        
        width: '500',
        bgcolor: '#333',
        opacity: 0.7,
        x: 'center',
        y: 'center',
        delay: 0,
        timeout: 0,
        buttons: {
            accept: "Yes, I'll give feedback",
            decline: 'No thanks'
        },
        hideOnClick: false,
        css: 'foresee-dhtml.css',
        hide: []
    },
    
    tracker: {
        width: '500',
        height: '370',
        timeout: 3,
        adjust: true,
        pause: 10,
        alert: {
            enabled: false,
            message: 'Your survey is availible.'
        },
        url: 'tracker.html',
        
        locales: [{
            locale: 'de',
            url: 'tracker_de.html'
        }, {
            locale: 'ja',
            url: 'tracker_ja.html'
        }]
    },
    
    survey: {
        width: 550,
        height: 600,
        loading: false
    },
    
    qualifier: {
        width: '625',
        height: '500',
        bgcolor: '#333',
        opacity: 0.7,
        x: 'center',
        y: 'center',
        delay: 0,
        buttons: {
            accept: 'Continue'
        },
        hideOnClick: false,
        css: false,
        url: 'qualifying.html'
    },
    
    cancel: {
        url: 'cancel.html',
        width: '500',
        height: '300'
    },
    
    loading: {
        url: 'survey_loading.html',
        
        locales: [{
            locale: 'de',
            url: 'survey_loading_de.html'
        }, {
            locale: 'ja',
            url: 'survey_loading_ja.html'
        }]
    },
    
    pop: {
        what: 'survey',
        after: 'leaving-site',
        pu: false,
        tracker: true
    },
    
    meta: {
        referrer: true,
        terms: true,
        ref_url: true,
        url: true,
        url_params: false
    },
    
    events: {
        enabled: true,
        id: true,
        codes: {
            purchase: 800,
            items: 801,
            dollars: 802
        },
        pd: 7,
        custom: {}
    },
    
    pool: 100,
    
    previous: false,
    
    analytics: {
        google: false
    },
    
    mode: 'first-party',
    
    cpps: {
        downloads: {
            source: 'url',
            init: 'None',
            patterns: [{
                regex: 'get.adobe.com',
                value: 'get'
            }, {
                regex: 'get2.adobe.com',
                value: 'get2'
            }]
        }
    }
};
