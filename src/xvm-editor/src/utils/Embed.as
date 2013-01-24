package utils
{
    public final class Embed
    {
        // fonts
        [Embed(source="../assets/HeliosCondC.otf", fontFamily="$FieldFont",
            fontStyle="normal", fontWeight="normal", embedAsCFF="false")]
        private static var $FieldFontClassRegular:Class;
        [Embed(source="../assets/HeliosCondC-Bold.otf", fontFamily="$FieldFont",
            fontStyle="normal", fontWeight="bold", embedAsCFF="false")]
        private static var $FieldFontClassBold:Class;
        [Embed(source="../assets/HeliosCondC-Italic.otf", fontFamily="$FieldFont",
            fontStyle="italic", fontWeight="normal", embedAsCFF="false")]
        private static var $FieldFontClassItalic2:Class;
        [Embed(source="../assets/HeliosCondC-BoldItalic.otf", fontFamily="$FieldFont",
            fontStyle="italic", fontWeight="bold", embedAsCFF="false")]
        private static var $FieldFontClassBoldItalic:Class;

        [Embed(source="../assets/HeliosCondC.otf", fontFamily="$FieldFont",
            fontStyle="normal", fontWeight="normal", embedAsCFF="true")]
        private static var $FieldFontClassCFF:Class;

        // images
        [Embed(source="images/add.png")]
        public static const add:Class;
        [Embed(source="images/delete.png")]
        public static const del:Class;
        [Embed("images/syscolors.png")]
        public static const syscolors:Class;
        [Embed("images/macros.png")]
        public static const macros:Class;

        // macros
        [Embed("images/macros/battles.png")]
        public static const battles:Class;
        [Embed("images/macros/clan.png")]
        public static const clan:Class;
        [Embed("images/macros/dead.png")]
        public static const dead:Class;
        [Embed("images/macros/dmg.png")]
        public static const dmg:Class;
        [Embed("images/macros/dmg_avg.png")]
        public static const dmg_avg:Class;
        [Embed("images/macros/dmg_kind.png")]
        public static const dmg_kind:Class;
        [Embed("images/macros/dmg_player.png")]
        public static const dmg_player:Class;
        [Embed("images/macros/dmg_ratio.png")]
        public static const dmg_ratio:Class;
        [Embed("images/macros/dmg_total.png")]
        public static const dmg_total:Class;
        [Embed("images/macros/e.png")]
        public static const e:Class;
        [Embed("images/macros/eff.png")]
        public static const eff:Class;
        [Embed("images/macros/eff_4.png")]
        public static const eff_4:Class;
        [Embed("images/macros/extra.png")]
        public static const extra:Class;
        [Embed("images/macros/hp.png")]
        public static const hp:Class;
        [Embed("images/macros/hp_max.png")]
        public static const hp_max:Class;
        [Embed("images/macros/hp_ratio.png")]
        public static const hp_ratio:Class;
        [Embed("images/macros/kb.png")]
        public static const kb:Class;
        [Embed("images/macros/kb_3.png")]
        public static const kb_3:Class;
        [Embed("images/macros/level.png")]
        public static const level:Class;
        [Embed("images/macros/rlevel.png")]
        public static const rlevel:Class;
        [Embed("images/macros/n.png")]
        public static const n:Class;
        [Embed("images/macros/n_player.png")]
        public static const n_player:Class;
        [Embed("images/macros/name.png")]
        public static const name:Class;
        [Embed("images/macros/nick.png")]
        public static const nick:Class;
        [Embed("images/macros/points.png")]
        public static const points:Class;
        [Embed("images/macros/rating.png")]
        public static const rating:Class;
        [Embed("images/macros/rating_3.png")]
        public static const rating_3:Class;
        [Embed("images/macros/short_nick.png")]
        public static const short_nick:Class;
        [Embed("images/macros/short_vehicle.png")]
        public static const short_vehicle:Class;
        [Embed("images/macros/speed.png")]
        public static const speed:Class;
        [Embed("images/macros/squad.png")]
        public static const squad:Class;
        [Embed("images/macros/t_battles.png")]
        public static const t_battles:Class;
        [Embed("images/macros/t_battles_4.png")]
        public static const t_battles_4:Class;
        [Embed("images/macros/t_hb.png")]
        public static const t_hb:Class;
        [Embed("images/macros/t_hb_3.png")]
        public static const t_hb_3:Class;
        [Embed("images/macros/t_kb.png")]
        public static const t_kb:Class;
        [Embed("images/macros/t_kb_0.png")]
        public static const t_kb_0:Class;
        [Embed("images/macros/t_kb_4.png")]
        public static const t_kb_4:Class;
        [Embed("images/macros/t_rating.png")]
        public static const t_rating:Class;
        [Embed("images/macros/t_rating_3.png")]
        public static const t_rating_3:Class;
        [Embed("images/macros/t_wins.png")]
        public static const t_wins:Class;
        [Embed("images/macros/tanks.png")]
        public static const tanks:Class;
        [Embed("images/macros/time.png")]
        public static const time:Class;
        [Embed("images/macros/time_sec.png")]
        public static const time_sec:Class;
        [Embed("images/macros/teff.png")]
        public static const teff:Class;
        [Embed("images/macros/tdb.png")]
        public static const tdb:Class;
        [Embed("images/macros/tdv.png")]
        public static const tdv:Class;
        [Embed("images/macros/tfb.png")]
        public static const tfb:Class;
        [Embed("images/macros/tsb.png")]
        public static const tsb:Class;
        [Embed("images/macros/turret.png")]
        public static const turret:Class;
        [Embed("images/macros/twr.png")]
        public static const twr:Class;
        [Embed("images/macros/vehicle.png")]
        public static const vehicle:Class;
        [Embed("images/macros/vtype.png")]
        public static const vtype:Class;
        [Embed("images/macros/wins.png")]
        public static const wins:Class;
        [Embed("images/macros/wn.png")]
        public static const wn:Class;

        // color
        [Embed("images/macros/c_dmg_kind.png")]
        public static const c_dmg_kind:Class;
        [Embed("images/macros/c_hp.png")]
        public static const c_hp:Class;
        [Embed("images/macros/c_hp_ratio.png")]
        public static const c_hp_ratio:Class;
        [Embed("images/macros/c_vtype.png")]
        public static const c_vtype:Class;
        [Embed("images/macros/c_e.png")]
        public static const c_e:Class;
        [Embed("images/macros/c_eff.png")]
        public static const c_eff:Class;
        [Embed("images/macros/c_rating.png")]
        public static const c_rating:Class;
        [Embed("images/macros/c_kb.png")]
        public static const c_kb:Class;
        [Embed("images/macros/c_system.png")]
        public static const c_system:Class;
        [Embed("images/macros/c_t_rating.png")]
        public static const c_t_rating:Class;
        [Embed("images/macros/c_t_battles.png")]
        public static const c_t_battles:Class;
        [Embed("images/macros/c_tdb.png")]
        public static const c_tdb:Class;
        [Embed("images/macros/c_tdv.png")]
        public static const c_tdv:Class;
        [Embed("images/macros/c_tfb.png")]
        public static const c_tfb:Class;
        [Embed("images/macros/c_tsb.png")]
        public static const c_tsb:Class;
        [Embed("images/macros/c_twr.png")]
        public static const c_twr:Class;
        [Embed("images/macros/c_wn.png")]
        public static const c_wn:Class;

        // alpha
        [Embed("images/macros/a_hp.png")]
        public static const a_hp:Class;
        [Embed("images/macros/a_hp_ratio.png")]
        public static const a_hp_ratio:Class;

    }
}
