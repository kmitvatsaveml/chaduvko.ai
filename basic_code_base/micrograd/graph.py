"""Graphviz helpers for visualising computation graphs.

Provides `trace(root)` and `draw_dot(root)` compatible with the
`draw_dot` you pasted. Uses `graphviz.Digraph` when available.
"""

from typing import Set, Tuple


def trace(root) -> Tuple[Set, Set]:
    """Collect all nodes and edges reachable from `root`.

    Returns:
        (nodes, edges) where nodes is a set of Value instances and
        edges is a set of (src, dst) pairs.
    """
    nodes = set()
    edges = set()

    def build(v):
        if v not in nodes:
            nodes.add(v)
            for child in getattr(v, 'prev', ()):  # child is a predecessor
                edges.add((child, v))
                build(child)

    build(root)
    return nodes, edges


def draw_dot(root):
    """Return a Graphviz `Digraph` for the computation graph rooted at `root`.

    If `graphviz` is not installed, raises ImportError with guidance.
    """
    try:
        from graphviz import Digraph
    except Exception as e:
        raise ImportError(
            "graphviz python package is required for draw_dot. Install with: pip install graphviz"
        ) from e

    dot = Digraph(format='svg', graph_attr={'rankdir': 'LR'})
    nodes, edges = trace(root)

    for n in nodes:
        uid = str(id(n))
        label = "{ %s | val %.4f | grad %.4f }" % (
            getattr(n, 'label', ''), getattr(n, 'val', 0.0), getattr(n, 'grad', 0.0)
        )
        dot.node(name=uid, label=label, shape='box3d')

        op = getattr(n, 'op', '')
        if op:
            dot.node(name=uid + op, label=op)
            dot.edge(uid + op, uid)

    for n1, n2 in edges:
        # if the destination has an op node, point the edge at that op node
        op = getattr(n2, 'op', '')
        if op:
            dot.edge(str(id(n1)), str(id(n2)) + op)
        else:
            dot.edge(str(id(n1)), str(id(n2)))

    return dot
