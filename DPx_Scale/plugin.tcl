set plugin_name "DPx_Scale"

namespace eval ::plugins::${plugin_name} {
    # These are shown in the plugin selection page
    variable author "Damian"
    variable contact "via Diaspora"
    variable version 1.0
    variable description "Display the scale"


    proc build_ui {} {
        # Unique name per page
        set page_name "DPx_scale_settings"

        # Background image and "Done" button
        dui add canvas_item rect $page_name 0 0 2560 1600 -fill "#d7d9e6" -width 0
        dui add canvas_item rect $page_name 10 188 2552 1424 -fill "#ededfa" -width 0
        dui add canvas_item rect $page_name 220 412 2344 1192 -fill #fff -width 3 -outline #e9e9ed
        dui add canvas_item line $page_name 12 186 2552 186 -fill "#c7c9d5" -width 3
        dui add canvas_item line $page_name 2552 186 2552 1424 -fill "#c7c9d5" -width 3
        dui add dbutton $page_name 1034 1250 \
            -bwidth 492 -bheight 120 \
            -shape round -fill #c1c5e4 \
            -label [translate "Exit"] -label_font Helv_10_bold -label_fill #fAfBff -label_pos {0.5 0.5} \
            -command {say [translate {Done}] $::settings(sound_button_in); ::plugins::DPx_Scale::save_DPx_Scale_settings; page_to_show_when_off extensions; }

        # Headline
        dui add dtext $page_name 1280 300 -text [translate "DPx Scale"] -font Helv_20_bold -fill "#444444" -anchor "center" -justify "center"

        dui add dtext $page_name 600 520 -text [translate "screen saver scale"] -font [dui font get Roboto-Regular 22] -fill "#999" -anchor "center" -justify "center"
        dui add dbutton $page_name 380 600 \
            -bwidth 440 -bheight 160 -initial_state normal\
            -shape round -fill #c1c5e4 -tags DPx_ss_scale_setting_button_off \
            -label [translate "HIDDEN"] -label_font [dui font get Roboto-Regular 20] -label_fill #fAfBff -label_pos {0.5 0.5} \
            -command {::plugins::DPx_Scale::DPx_toggle_ss_state; ::plugins::DPx_Scale::DPx_check_ss_state}
        dui add dbutton $page_name 380 600 \
            -bwidth 440 -bheight 160 -initial_state normal\
            -shape round -fill #c1c5e4 -tags DPx_ss_scale_setting_button_on \
            -label [translate "SHOWING"] -label_font [dui font get Roboto-Regular 20] -label_fill #ff9421 -label_pos {0.5 0.5} \
            -command {::plugins::DPx_Scale::DPx_toggle_ss_state; ::plugins::DPx_Scale::DPx_check_ss_state}
        dui add dbutton $page_name 380 800 \
            -bwidth 440 -bheight 160 \
            -shape round -fill #c1c5e4 \
            -label [translate "Auto-sleep (minutes)"] -label_font [dui font get Roboto-Regular 16] -label_fill #fAfBff -label_width 400 -label_pos {0.5 0.8} \
        dui add canvas_item rect $page_name 550 825 650 895 -fill #fff -width 1 -outline #eee
        dui add variable $page_name 600 860 -justify center -anchor center -font [dui font get Roboto-Regular 22] -fill #888 -textvariable {$::DPx_Scale_settings(saver_scale_seconds)}
        dui add dbutton $page_name 600 800 \
            -bwidth 220 -bheight 160 -tags hour_up \
            -label \uf105 -label_font [dui font get "Font Awesome 5 Pro-Regular-400" 18] -label_fill #888 -label_pos {0.65 0.4} \
            -command {
                if {$::DPx_Scale_settings(saver_scale_seconds) >= 1} {
                    set ::DPx_Scale_settings(saver_scale_seconds) [expr $::DPx_Scale_settings(saver_scale_seconds) + 1]
                } else {
                    set ::DPx_Scale_settings(saver_scale_seconds) 1
                }
                if {$::DPx_Scale_settings(saver_scale_seconds) > 30} {
                    set ::DPx_Scale_settings(saver_scale_seconds) 30
                }
            }
        dui add dbutton $page_name 380 800 \
            -bwidth 220 -bheight 160 -tags hour_down \
            -label \uf104 -label_font [dui font get "Font Awesome 5 Pro-Regular-400" 18] -label_fill #888 -label_pos {0.35 0.4} \
            -command {
                if {$::DPx_Scale_settings(saver_scale_seconds) <= 30} {
                    set ::DPx_Scale_settings(saver_scale_seconds) [expr $::DPx_Scale_settings(saver_scale_seconds) - 1]
                } else {
                    set ::DPx_Scale_settings(saver_scale_seconds) 30
                }
                if {$::DPx_Scale_settings(saver_scale_seconds) < 1} {
                    set ::DPx_Scale_settings(saver_scale_seconds) 1
                }
            }


        dui add dtext $page_name 1280 520 -text [translate "Insight skin scale"] -font [dui font get Roboto-Regular 22] -fill "#999" -anchor "center" -justify "center"
        dui add dbutton $page_name 1060 600 \
            -bwidth 440 -bheight 160 -initial_state normal\
            -shape round -fill #c1c5e4 -tags DPx_is_scale_setting_button_off \
            -label [translate "HIDDEN"] -label_font [dui font get Roboto-Regular 20] -label_fill #fAfBff -label_pos {0.5 0.5} \
            -command {::plugins::DPx_Scale::DPx_toggle_is_state; ::plugins::DPx_Scale::DPx_check_is_state}
        dui add dbutton $page_name 1060 600 \
            -bwidth 440 -bheight 160 -initial_state normal\
            -shape round -fill #c1c5e4 -tags DPx_is_scale_setting_button_on \
            -label [translate "SHOWING"] -label_font [dui font get Roboto-Regular 20] -label_fill #ff9421 -label_pos {0.5 0.5} \
            -command {::plugins::DPx_Scale::DPx_toggle_is_state; ::plugins::DPx_Scale::DPx_check_is_state}


        DPx_ssButton
        DPx_isButton
        ::plugins::DPx_Scale::DPx_check_ss_state
        ::plugins::DPx_Scale::DPx_check_is_state
        return $page_name
    }

    set ::DPx_indicator #ccc


    set ::DPx_Scale_settings(saver_scale_seconds) 3
    set ::DPx_Scale_settings(saver_scale_display_on) 0
    set ::DPx_Scale_settings(Insight_scale_display_on) 0
    set ::DPx_scale_insight_pages ""
    if {$::settings(skin) == "Insight Dark"} {
        set ::DPx_scale_insight_pages "off espresso_3"
        set ::DPx_insight_fill #373d42
    }
    if {$::settings(skin) == "Insight"} {
        set ::DPx_scale_insight_pages "off espresso_3"
        set ::DPx_insight_fill #c1c5e4
    }

    ###### scale on saver pages
    proc DPx_ssButton {} {
        dui add dbutton "saver" 1160 1230 \
            -bwidth 240 -bheight 240 -tags DPx_ss_button_live -initial_state normal \
            -shape round -fill #222 \
            -labelvariable {[round_to_one_digits $::de1(scale_sensor_weight)]g} -label_font [dui font get Roboto-Regular 24] -label_fill #fff -label_pos {0.5 0.5} \
            -command {::plugins::DPx_Scale::DPx_reset_ss_timer; scale_tare; catch {ble_connect_to_scale}}

        dui add dbutton "saver" 1160 1230 \
            -bwidth 240 -bheight 240 -tags DPx_ss_button_sleep -initial_state normal \
            -shape round -fill #222 \
            -labelvariable {scale} -label_font [dui font get Roboto-Regular 24] -label_fill #555 -label_pos {0.5 0.5} \
        -command {::plugins::DPx_Scale::DPx_reset_ss_timer; ::plugins::DPx_Scale::DPx_ss_timer_run; catch {ble_connect_to_scale}; if {$::DPx_Scale_settings(saver_scale_display_on) == 1} {scale_enable_lcd}; after 300 {dui item config saver DPx_ss_button_sleep* -state hidden}; dui item config saver DPx_ss_button_sleep* -initial_state hidden}
    }

    proc DPx_reset_ss_timer {} {
        set ::DPx_ss_timer_start [clock seconds]
        set ::DPx_scale_previous_value $::de1(scale_sensor_weight)
    }

    proc DPx_ss_timer_run {} {
        if {$::de1(scale_sensor_weight) > [expr {$::DPx_scale_previous_value + 0.5}] || $::de1(scale_sensor_weight) < [expr {$::DPx_scale_previous_value - 0.5}]} {
            ::plugins::DPx_Scale::DPx_reset_ss_timer
            set ::DPx_scale_previous_value $::de1(scale_sensor_weight)
        }
        if {[clock seconds] > [expr {$::DPx_ss_timer_start + $::DPx_Scale_settings(saver_scale_seconds)}]} {
            if {$::de1(current_context) == "saver"} {
                dui item config saver DPx_ss_button_sleep* -state normal
            }
            dui item config saver DPx_ss_button_sleep* -initial_state normal
            if {$::DPx_Scale_settings(saver_scale_display_on) == 1} {scale_disable_lcd}
        } else {
            after 100 ::plugins::DPx_Scale::DPx_ss_timer_run
        }
    }

    proc DPx_toggle_ss_state {} {
        if {$::DPx_Scale_settings(saver_scale_display_on) == 0} {
            set ::DPx_Scale_settings(saver_scale_display_on) 1
        } else {
            set ::DPx_Scale_settings(saver_scale_display_on) 0
        }
    }

    proc DPx_check_ss_state {} {
        if {$::DPx_Scale_settings(saver_scale_display_on) == 0} {
            if {$::de1(current_context) == "DPx_scale_settings"} {
                dui item config DPx_scale_settings DPx_ss_scale_setting_button_on* -state hidden
                dui item config DPx_scale_settings DPx_ss_scale_setting_button_off* -state normal
            }
            dui item config DPx_scale_settings DPx_ss_scale_setting_button_on* -initial_state hidden
            dui item config DPx_scale_settings DPx_ss_scale_setting_button_off* -initial_state normal
            dui item config saver DPx_ss_button_live* -initial_state hidden
            dui item config saver DPx_ss_button_sleep* -initial_state hidden
        } else {
            if {$::de1(current_context) == "DPx_scale_settings"} {
                dui item config DPx_scale_settings DPx_ss_scale_setting_button_on* -state normal
                dui item config DPx_scale_settings DPx_ss_scale_setting_button_off* -state hidde
            }
            dui item config DPx_scale_settings DPx_ss_scale_setting_button_on* -initial_state normaln
            dui item config DPx_scale_settings DPx_ss_scale_setting_button_off* -initial_state hidden
            dui item config saver DPx_ss_button_live* -initial_state normal
            dui item config saver DPx_ss_button_sleep* -initial_state normal
        }
    }

    ###### scale on Insight pages

    proc DPx_isButton {} {
        dui add dbutton $::DPx_scale_insight_pages 2060 1315 \
            -bwidth 180 -bheight 80 -tags DPx_is_button_live -initial_state normal \
            -shape round -fill $::DPx_insight_fill \
            -labelvariable {[round_to_one_digits $::de1(scale_sensor_weight)]g} -label_font [dui font get Roboto-Regular 18] -label_fill #fff -label_pos {0.5 0.5} \
            -command {scale_tare; catch {ble_connect_to_scale}}
    }

    proc DPx_toggle_is_state {} {
        if {$::DPx_Scale_settings(Insight_scale_display_on) == 0} {
            set ::DPx_Scale_settings(Insight_scale_display_on) 1
        } else {
            set ::DPx_Scale_settings(Insight_scale_display_on) 0
        }
    }

    proc DPx_check_is_state {} {
        if {$::DPx_Scale_settings(Insight_scale_display_on) == 0} {
            if {$::de1(current_context) == "DPx_scale_settings"} {
                dui item config DPx_scale_settings DPx_is_scale_setting_button_on* -state hidden
                dui item config DPx_scale_settings DPx_is_scale_setting_button_off* -state normal
            }
            dui item config DPx_scale_settings DPx_is_scale_setting_button_on* -initial_state hidden
            dui item config DPx_scale_settings DPx_is_scale_setting_button_off* -initial_state normal
            dui item config $::DPx_scale_insight_pages DPx_is_button_live* -initial_state hidden
        } else {
            if {$::de1(current_context) == "DPx_scale_settings"} {
                dui item config DPx_scale_settings DPx_is_scale_setting_button_on* -state normal
                dui item config DPx_scale_settings DPx_is_scale_setting_button_off* -state hidden
            }
            dui item config DPx_scale_settings DPx_is_scale_setting_button_on* -initial_state normal
            dui item config DPx_scale_settings DPx_is_scale_setting_button_off* -initial_state hidden
            dui item config $::DPx_scale_insight_pages DPx_is_button_live* -initial_state normal
        }
    }



    ###### settings
    proc save_DPx_Scale_settings {} {
        set fn [homedir]/plugins/DPx_Scale/DPx_Scale_settings.tdb
        upvar ::DPx_Scale_settings item
        set data {}
        foreach k [lsort -dictionary [array names item]] {
            set v $item($k)
            append data [subst {[list $k] [list $v]\n}]
        }
        write_file $fn $data
    }

    proc load_DPx_Scale_settings {} {
        set fn [homedir]/plugins/DPx_Scale/DPx_Scale_settings.tdb
        array set ::DPx_Scale_settings [encoding convertfrom utf-8 [read_binary_file $fn]]
    }

    ::plugins::DPx_Scale::load_DPx_Scale_settings
    ::plugins::DPx_Scale::DPx_check_ss_state
    ######

    proc main {} {
        plugins gui DPx_Scale [build_ui]
    }
}
