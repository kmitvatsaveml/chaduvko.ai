"""Graph demo: builds a tiny computation and renders the graph to file.

Run from repo root:
    python micrograd/graph_demo.py

Output: `comp_graph.svg` (requires the `graphviz` package and Graphviz system binary).
"""

import os, sys
sys.path.insert(0, os.path.dirname(__file__))

from engine.value import Value

from graph import draw_dot


def build_sample():
    a = Value(2.0, label='a')
    b = Value(-3.0, label='b')
    c = a * b; c.label = 'c'
    d = c + a; d.label = 'd'
    e = d.exp(); e.label = 'e'
    loss = e / Value(2.0); loss.label = 'loss'
    return loss


if __name__ == '__main__':
    root = build_sample()
    # run backward so gradients are populated (optional)
    root.backward()

    try:
        dot = draw_dot(root)
    except ImportError as exc:
        print(str(exc))
        sys.exit(1)

    out = 'comp_graph'
    dot.render(out, cleanup=True)
    print(f'Wrote {out}.svg')
