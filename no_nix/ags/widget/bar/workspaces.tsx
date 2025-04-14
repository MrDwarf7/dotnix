import { Gdk } from "astal/gtk3";
import { bind } from "astal";
import Hyprland from "gi://AstalHyprland";

type WorkspacesProps = {
  monitor: Gdk.Monitor;
};

export function Workspaces({ monitor }: WorkspacesProps) {
  const hypr = Hyprland.get_default();

  return (
    <eventbox
      className="bar-workspaces"
      onScroll={(_: any, e: { delta_y: number }) => {
        const isDown = e.delta_y > 0;
        if (isDown) {
          hypr.dispatch("workspace", "+1");
        } else {
          hypr.dispatch("workspace", "-1");
        }
      }}
    >
      <box>
        {bind(hypr, "workspaces").as((wss) =>
          wss
            .filter((ws: { id: number }) => !(ws.id >= -99 && ws.id <= -2)) // filter out special workspaces
            .filter((ws: { monitor: { name: any } }) => ws.monitor?.name === getMonitorName(monitor))
            .sort((a: { id: number }, b: { id: number }) => a.id - b.id)
            .map((ws: { focus: () => any; id: any }) => (
              <button onClicked={() => ws.focus()}>
                {/* {bind(hypr, "focusedWorkspace").as((fw) => (ws === fw ? "" : ws.id))} */}
                {bind(hypr, "focusedWorkspace").as((fw) => (ws === fw ? `|${ws.id}|` : ws.id))}
              </button>
            )),
        )}
      </box>
    </eventbox>
  );
}

const display = Gdk.Display.get_default();
function getMonitorName(gdkmonitor: Gdk.Monitor) {
  if (!display) {
    return null;
  }
  const screen = display.get_default_screen();
  for (let i = 0; i < display.get_n_monitors(); ++i) {
    if (gdkmonitor === display.get_monitor(i)) {
      return screen.get_monitor_plug_name(i);
    }
  }
  return null;
}
